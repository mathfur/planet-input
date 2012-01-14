# TODO: <g>を加える
# 最初のトリガー部分
# tdテーブル

$.obj2table = (obj) -> 
    inner = $.map(obj, (k, v) -> "<tr><td>#{k}</td><td>#{v}</td></tr>")
    $("<table>#{inner}</table>")

$('#main').bind('add-planet', (x, y, r1, r2, r3, hashs) ->
  $(document.createElementNS('http://www.w3.org/2000/svg', 'circle'))
    .attr(cx: x, cy: y, r:r1)
    .data('hashs', hashs)
    .bind('remove-all-satellites', ->
      @siblings().filter('.satellite').remove()
    )
    .click ->
      @data('hashs', @data('hashs')+[{}])
    .bind('update.planet-input', ->
      @data('hashs').each (i) ->
        hashs = @data('hashs')
        return if hashs.length is 0
        $(document.createElementNS('http://www.w3.org/2000/svg', 'circle'))
          circle = this
          .attr(cx: (x+r3*Math.cos(2*Math.PI*i/hashs.length)),
                cy: (y+r3*Math.sin(2*Math.PI*i/hashs.length)),
                r:  r2)
          .addClass('satellite')
          .mouseover ->
            $('#main').append(
              $('<div/>').attr('id','satellite-tooltip')
                         .append($.obj2table(@data('hash')))
                         .css(position: 'absolute', top: @attr('cx'), left: @attr('cy'), z-index: 2)
            )
          .mouseout ->
            $('#satellite-tooltip').remove();
          .click ->
              wnd = $('<div><form></form></div>')
                .append($.obj2table(@data('hash'))) 
                .append(
                  $('<button/>')
                    .attr(id: 'satellite-editor-cancel')
                    .click ->
                      wnd.trigger('close.planet-input')
                .append(
                  $('<button/>')
                    .attr(id: 'satellite-editor-ok')
                    .click ->
                      wnd.trigger('save.planet-input')
                      wnd.trigger('close.planet-input')
                .bind('close.planet-input', ->
                  @remove()
                .bind('save.planet-input', ->
                  result = {}
                  @find('input').each -> result[@name] = @val()
                  circle.data('hashs', circle.data('hashs')+[result])
                  circle.trigger('upload.planet-input')
                  

            )
    .trigger('update.planet-input')
)
