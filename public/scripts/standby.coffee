$ ->
  document.write = (p...) -> console.log(p)

  window.onhashchange = ->
    hash = window.location.hash.substring(1)
    if hash
      openLink(hash)
    else
      hideLink()

  cacheLinks = ->
    NProgress.start()
    total = $('.cache:not(.loaded)').length
    curr = 0
    stillInLoading = true
    old_pct = 0
    $('.cache:not(.loaded)').each (i, el) ->
      $el = $(el)
      $.get '/cache', {url: el.href}, (html) ->
        if html.err
          console.log(html.err)
        else
          console.log "fetched #{el.href}"
          id = $el.data('id')
          iframe = document.getElementById(id)
          iframe = iframe.contentWindow or iframe.contentDocument.document or iframe.contentDocument
          iframe.document.open()
          iframe.document.write(html.replace('window.top.location','hahaiwin'))
          iframe.document.close()
          waitForLoaded 0, id, $el, (el) ->
            curr++
            pct = Math.floor(curr / total * 100)
            console.log(pct)
            if stillInLoading
              if pct > 95
                stillInLoading = false
                setTimeout(() ->
                  NProgress.done()
                , 2000)
              else
                NProgress.set(curr / total)
            el.addClass('loaded')
          $el.on 'click', (e) ->
            e.preventDefault()
            $el.addClass('site-link-visited')
            id = $(@).data('id')
            $("#arrow-#{id}").addClass('arrow-seen')
            window.location.hash = id

  openLink = (id) ->
    $("##{id}").addClass('fucklightboxes')
    $('#x').show()
    # disable scrolling on parent
    document.body.style.overflow = 'hidden';

  hideLink = ->
    $('#overlay').removeClass('dark')
    $('iframe').removeClass('fucklightboxes')
    $('#x').hide()
    document.body.style.overflow = 'auto';

  $(document).keyup (e) ->
    window.location.hash = "" if e.keyCode is 27

  cacheLinks()
  $('#x').on 'click', -> window.location.hash = ""

  waitForLoaded = (i, id, $el, cb) ->
    iframe = document.getElementById(id)
    if i > 20 or iframe.contentWindow and iframe.contentWindow.document and iframe.contentWindow.document.body and iframe.contentWindow.document.body.innerHTML
      setTimeout (->
        cb($el)
      ), 200
    else
      setTimeout (->
        waitForLoaded(i+1, id, $el, cb)
      ), 200

  # $('#icons li:not(.add-section)').on 'click', (e) ->
  $('#icons').delegate 'li:not(.add-section)', 'click', (e) ->
    $this = $(@)
    $('#icons li').removeClass('selected')
    $this.addClass('selected')

    $('.content-section').removeClass('active-section')
    $("##{$this.data('section')}").addClass('active-section')


  $('#icons li.add-section').on 'click', (e) ->
    # open modal
    $('.modal').modal()

  $('#modal-subreddit').on 'keyup', (e) ->
    if e.keyCode is 13
      addToStandBy("reddit", $('#modal-subreddit').val())
      $('.modal').modal('hide')
      $('#modal-subreddit').val('')

  $('.modal-producthunt').on 'click', (e) ->
    addToStandBy("producthunt")
    $('.modal').modal('hide')

  addToStandBy = (service, subreddit = "") ->
    $.get '/add', {service, subreddit}, (posts) ->
      section = subreddit or service
      section += "-section"
      img = if subreddit then "Reddit_on.png" else "Product_on.png"
      $newTab = $("<li data-section='#{section}'><img src='/images/#{img}'></li>")
      $('#icons .add-section').before($newTab)

      html = "<div id='#{section}' class='content-section'>"
      posts.forEach (post, i) ->
        if subreddit
          html += """
            <div>
              <div class='section-link'>
                <div class='upvotes'>
                  <div class='arrow' id="arrow-#{section}-link-#{i}"></div>
                  <div>#{post.score}</div>
                </div>
                <div class='post-data'>
                  <a class='cache site-link' data-id='#{section}-link-#{i}' href='#{post.url}'>#{post.title}</a>
                  <span class='website'>(#{post.url.replace('http://','').replace('https://','').split(/[\/?#]/)[0]})</span>
                  <a class='cache comments' data-id='#{section}-comments-#{i}' href='http://reddit.com#{post.permalink}'>#{post.num_comments} comments
                  </a>
                </div>
              </div>
              <iframe sandbox="allow-same-origin" class='content' id='#{section}-link-#{i}'></iframe>
              <iframe class='content' id='#{section}-comments-#{i}'></iframe>
            </div>
          """
        # we only support producthunt atm
        else
          html += """
                <div>
                  <div class='section-link'>
                    <div class='upvotes'>
                      <div class='arrow'></div>
                      <div>#{ post.votes }</div>
                    </div>
                    <div class='post-data'>
                      <a class='cache site-link' data-id='product-hunt-link-#{ i }' href='#{ post.url }'>#{ post.title }</a>
                      <span class='website'>(#{ post.url.replace('http://','').replace('https://','').split(/[\/?#]/)[0] })</span>
                      <a class='cache comments' data-id='product-hunt-comments-#{ i }' href='http://producthunt.com#{ post.permalink }'>#{ post.comment_count } comments</a>
                    </div>
                  </div>
                  <iframe sandbox="allow-same-origin" class='content' id='product-hunt-link-#{ i }'></iframe>
                  <iframe class='content' id='product-hunt-comments-#{ i }'></iframe>
                </div>
                  """
      html += "</div>"
      $('#content-section-wrap').append html

      # click on the new tab
      $newTab.click()

      # start fetching the links
      cacheLinks()
