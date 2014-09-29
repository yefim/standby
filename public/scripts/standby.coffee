MAX_PINGS = 20

$ ->
  document.write = (p...) -> console.log(p)

  window.onhashchange = ->
    hash = window.location.hash.substring(1)
    if hash
      openLink(hash)
    else
      hideLink()

  cacheLinks = ->
    total = $('.cache:not(.loaded)').length
    curr = 0
    stillInLoading = true
    old_pct = 0
    $('#progressbar').attr('max', total)
    $('.cache:not(.loaded)').each (i, el) ->
      $el = $(el)
      $.get '/cache', {url: el.href}, (html) ->
        return console.log(html.err) if html.err
        console.log "fetched #{el.href}"
        id = $el.data('id')
        iframe = document.getElementById(id)
        iframe = iframe.contentWindow or iframe.contentDocument.document or iframe.contentDocument
        iframe.document.open()
        iframe.document.write(html.replace('window.top.location','hahaiwin'))
        iframe.document.close()
        waitForLoaded 0, iframe, $el, (el) ->
          curr++
          pct = Math.floor(curr / total * 100)
          el.addClass('loaded')
          if stillInLoading
            if pct == 100
              stillInLoading = false
              finishedLoading()
            else if pct > 95
              stillInLoading = false
              setTimeout(->
                finishedLoading()
              , 1000)
            else
              $('#progressbar').val(curr)
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
    document.body.style.overflow = 'hidden'

  hideLink = ->
    $('iframe').removeClass('fucklightboxes')
    $('#x').hide()
    document.body.style.overflow = 'auto'

  $(document).keyup (e) ->
    window.location.hash = "" if e.keyCode is 27

  # wait for background-image to load
  # http://stackoverflow.com/questions/5057990/how-can-i-check-if-a-background-image-is-loaded
  imageUrl = '/images/background.png'
  $('<img/>').attr('src', imageUrl).load ->
    $(@).remove()
    $('body').css('background-image', "url(#{imageUrl})")
    cacheLinks()

  $('#x').on 'click', -> window.location.hash = ""

  $('.tab-link').on 'click', (e) ->
    $this = $(@)
    tab = $this.data('tab')
    $("li[data-section='#{tab}']").click()

  waitForLoaded = (pings, iframe, $el, cb) ->
    if pings > MAX_PINGS or iframe.contentWindow and iframe.contentWindow.document and iframe.contentWindow.document.body and iframe.contentWindow.document.body.innerHTML
      # already pinged the same iframe enough times, assume it loaded
      setTimeout (->
        cb($el)
      ), 200
    else
      setTimeout (->
        waitForLoaded(pings+1, iframe, $el, cb)
      ), 200

  finishedLoading = ->
    $('#progressbar').val $('#progressbar').attr('max')
    $('#landing').addClass('landing')
    $('#index').addClass('index')

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
                      <a class='cache comments' data-id='product-hunt-comments-#{i}' href='http://producthunt.com#{post.permalink}'>#{post.comment_count} comments</a>
                    </div>
                  </div>
                  <iframe sandbox="allow-same-origin" class='content' id='product-hunt-link-#{i}'></iframe>
                  <iframe class='content' id='product-hunt-comments-#{ i }'></iframe>
                </div>
                  """
      html += "</div>"
      $('#content-section-wrap').append html

      # click on the new tab
      $newTab.click()

      # start fetching the links
      cacheLinks()
