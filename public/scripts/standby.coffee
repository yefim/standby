$ ->
  console.log "done"

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
      iframe.onload = -> $el.addClass('loaded')
      $el.on 'click', (e) ->
        e.preventDefault()
        id = $(@).data('id')
        $("##{id}").css('display', 'block')
