jQuery ->
  $('#observation_severity_id').parent().hide()
  severities = $('#observation_severity_id').html()
  console.log(severities)
  $('#observation_annex_operator_id').change -> changeSeverity('#observation_annex_operator_id')
  $('#observation_annex_governance_id').change -> changeSeverity('#observation_annex_governance_id')


  changeSeverity = (element_name) ->
    annex = $(element_name + ' :selected').text()

    escaped_annex = annex.replace(/([ #;&,.+*~\':"!^[\]()=>|\/@])/g, '\\$1')
    console.log('Annex- ' + escaped_annex)
    options = $(severities).filter("optgroup[label='#{escaped_annex}']").html()
    console.log('options- ' + options)
    if options
      $('#observation_severity_id').html(options)
      $('#observation_severity_id').parent().show()
    else
      $('#observation_severity_id').empty()
      $('#observation_severity_id').parent().hide()