$ ->
  console.log "done"
  window.onload = -> console.log('loaded')
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
      waitForLoaded(id, $el, (el) ->
        el.addClass('loaded')
      )
      $el.on 'click', (e) ->
        e.preventDefault()
        id = $(@).data('id')
        $("##{id}").css('display', 'block')

waitForLoaded = (id, $el, cb) ->
  iframe = document.getElementById(id)
  if iframe.contentWindow and iframe.contentWindow.document and iframe.contentWindow.document.body and iframe.contentWindow.document.body.innerHTML
    console.log('loaded!!!!!!!!!!!')
    setTimeout((()->
      cb($el)
    ), 500)
  else
    setTimeout((() ->
      waitForLoaded(id, $el, cb)
      ),333)
