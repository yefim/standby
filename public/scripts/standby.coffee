MAX_PINGS = 40
CHUNK_SIZE = 5

$ ->
  document.write = (p...) -> console.log(p)

  window.onhashchange = ->
    hash = window.location.hash.substring(1)
    if hash
      openLink(hash)
    else
      hideLink()

  $progressbar = $('#progressbar')

  cacheLinks = ->
    allElements = $('a.cache:not(.loaded)')
    total = allElements.length
    curr = 0
    stillInLoading = true
    $progressbar.attr('max', total)

    i = 0
    len = allElements.length
    while i < len
      do (els = allElements.slice(i, i + CHUNK_SIZE).toArray()) ->
        i += CHUNK_SIZE
        urls = els.map (e) -> e.href
        $.get '/batch', {urls}, (htmls) ->
          _.each htmls, (html, index) ->
            el = els[index]
            $el = $(el)
            console.log "fetched #{el.href}"
            id = $el.data('id')
            iframe = document.getElementById(id)
            iframe = iframe.contentWindow or iframe.contentDocument.document or iframe.contentDocument
            iframe.document.open()
            iframe.document.write(html.replace('window.top.location', 'hahaiwin'))
            iframe.document.close()
            $el.on 'click', (e) ->
              e.preventDefault()
              $(@).addClass('site-link-visited')
              id = $(@).data('id')
              $("#arrow-#{id}").addClass('arrow-seen')
              window.location.hash = id

    waitForLoaded = (pings, els) ->
      if pings > MAX_PINGS
        stillInLoading = false
        finishedLoading()
        return
      _.each els, (el, i) ->
        $el = $(el)
        id = $el.data('id')
        contents = $("##{id}").contents().find('body').html() or ''
        if contents.length
          els.splice(i, 1)
          $el.addClass('loaded')
          curr += 1
          pct = Math.round(curr / total * 100)
          if stillInLoading
            if pct == 100
              stillInLoading = false
              finishedLoading()
            else if pct > 95
              stillInLoading = false
              setTimeout(finishedLoading, 750)
            else
              $progressbar.val(curr)
      setTimeout(waitForLoaded.bind(null, pings+1, els), 250) if stillInLoading

    waitForLoaded(0, _.clone(allElements))

  openLink = (id) ->
    $("##{id}").addClass('fucklightboxes')
    $('#x').show()
    # disable scrolling on parent
    document.body.style.overflow = 'hidden'

  hideLink = ->
    $('iframe').removeClass('fucklightboxes')
    $('#x').hide()
    document.body.style.overflow = 'auto'

  $(document).on 'keyup', (e) ->
    window.location.hash = "" if (e.which or e.keyCode) is 27

  # First, disable all links
  $('.cache').on 'click', -> return false
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

  finishedLoading = ->
    $progressbar.val($progressbar.attr('max'))
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
