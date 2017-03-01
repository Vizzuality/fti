jQuery ->
  $('#observations_steps #observation_severity_id').parent().hide()
  severities = $('#observation_severity_id').html()
  console.log(severities)
  $('#observations_steps #observation_annex_operator_id').change -> changeSeverity('#observation_annex_operator_id')
  $('#observations_steps #observation_annex_governance_id').change -> changeSeverity('#observation_annex_governance_id')


  changeSeverity = (element_name) ->
    annex = $(element_name + ' :selected').text()

    escaped_annex = annex.replace(/([ #;&,.+*~\':"!^[\]()=>|\/@])/g, '\\$1')
    console.log('Annex- ' + escaped_annex)
    options = $(severities).filter("optgroup[label='#{escaped_annex}']").html()
    console.log('options- ' + options)
    if options
      $('#observations_steps #observation_severity_id').html(options)
      $('#observations_steps #observation_severity_id').parent().show()
    else
      $('#observations_steps #observation_severity_id').empty()
      $('#observations_steps #observation_severity_id').parent().hide()
