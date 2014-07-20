$ ->
  hideLink = ->
    $('#overlay').removeClass('dark')
    $('iframe').removeClass('fucklightboxes')
    document.body.style.overflow = 'auto';

  $(document).keyup (e) ->
    hideLink() if e.keyCode is 27

  $('.cache').each (i, el) ->
    $el = $(el)
    $.get '/cache', {url: el.href}, (html) ->
      console.log "fetched #{el.href}"
      id = $el.data('id')
      iframe = document.getElementById(id)
      iframe = iframe.contentWindow or iframe.contentDocument.document or iframe.contentDocument
      iframe.document.open()
      iframe.document.write(html)
      iframe.document.close()
      waitForLoaded id, $el, (el) ->
        el.addClass('loaded')
      $el.on 'click', (e) ->
        e.preventDefault()
        id = $(@).data('id')
        $("##{id}").addClass('fucklightboxes')
        $('#overlay').addClass('dark')
        # disable scrolling on parent
        document.body.style.overflow = 'hidden';
        $('#overlay').on 'click', (e) ->
          e.preventDefault()
          hideLink()
          $('#overlay').off('click')

  $('.left-text').each (i, el) ->
    $el = $(el)
    $el.on 'click', (e) ->
      e.preventDefault()
      target = @.target
      $('.active-section').each (j, ell) ->
        $(ell).removeClass('active-section')
      $("##{target}").addClass('active-section')

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
