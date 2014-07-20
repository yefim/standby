$ ->
  window.onhashchange = ->
    hash = window.location.hash.substring(1)
    if hash
      openLink(hash)
    else
      hideLink()

  cacheLinks = ->
    $('.cache:not(.loaded)').each (i, el) ->
      $el = $(el)
      $.get '/cache', {url: el.href}, (html) ->
        console.log "fetched #{el.href}"
        id = $el.data('id')
        iframe = document.getElementById(id)
        iframe = iframe.contentWindow or iframe.contentDocument.document or iframe.contentDocument
        iframe.document.open()
        iframe.document.write(html.replace('window.top.location','hahaiwin'))
        iframe.document.close()
        waitForLoaded id, $el, (el) ->
          el.addClass('loaded')
        $el.on 'click', (e) ->
          e.preventDefault()
          id = $(@).data('id')
          window.location.hash = id

  openLink = (id) ->
    $("##{id}").addClass('fucklightboxes')
    $('#overlay').addClass('dark')
    $('#x').show()
    # disable scrolling on parent
    document.body.style.overflow = 'hidden';
    $('#overlay').on 'click', (e) ->
      e.preventDefault()
      window.location.hash = ""
      $('#overlay').off('click')

  hideLink = ->
    $('#overlay').removeClass('dark')
    $('iframe').removeClass('fucklightboxes')
    $('#x').hide()
    document.body.style.overflow = 'auto';

  $(document).keyup (e) ->
    window.location.hash = "" if e.keyCode is 27

  cacheLinks()
  $('#x').on('click', hideLink)

  waitForLoaded = (id, $el, cb) ->
    iframe = document.getElementById(id)
    if iframe.contentWindow and iframe.contentWindow.document and iframe.contentWindow.document.body and iframe.contentWindow.document.body.innerHTML
      setTimeout (->
        cb($el)
      ), 500
    else
      setTimeout (->
        waitForLoaded(id, $el, cb)
      ), 200

  # $('#icons li:not(.add-section)').on 'click', (e) ->
  $('#icons').delegate 'li:not(.add-section)', 'click', (e) ->
    $this = $(@)
    $('#icons li').removeClass('selected')
    $this.addClass('selected')

    $('.content-section').removeClass('active-section')
    $("##{$this.data('section')}").addClass('active-section')


  $('#icons li.add-section').on 'click', (e) ->
    service = "reddit"
    subreddit = "askreddit"
    # open modal
    $.get '/add', {service, subreddit}, (posts) ->
      console.log posts
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
                <a class='cache site-link' data-id='#{section}-link-#{i}' href='#{post.url}'>#{post.title}</a>
                <span class='website'>(#{post.url.replace('http://','').replace('https://','').split(/[/?#]/)[0]})</span>
                <a class='cache comments' data-id='#{section}-comments-#{i}' href='http://reddit.com#{post.permalink}'>Comments</a>
              </div>
              <iframe class='content' id='#{section}-link-#{i}'></iframe>
              <iframe class='content' id='#{section}-comments-#{i}'></iframe>
            </div>
          """
        # we only support producthunt atm
        else
          html += """
            <div>
              <div class='section-link'>
                <a class='cache site-link' data-id='#{section}-link-#{i}' href='#{post.url}'>#{post.title}</a>
                <span class='website'>(#{post.url.replace('http://','').replace('https://','').split(/[/?#]/)[0]})</span>
                <a class='cache comments' data-id='#{section}-comments-#{i}' href='http://producthunt.com#{post.permalink}'>Comments</a>
              </div>
              <iframe class='content' id='#{section}-link-#{i}'></iframe>
              <iframe class='content' id='#{section}-comments-#{i}'></iframe>
            </div>
          """
      html += "</div>"
      $('#content-section-wrap').append html

      # click on the new tab
      $newTab.click()

      # start fetching the links
      cacheLinks()
