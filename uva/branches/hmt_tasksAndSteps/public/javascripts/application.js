// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
  $("job_department").autocomplete(["Savanna", "Anaheim", "Cypress", "Western", "Loara", "Magnolia", "Kennedy"], {
	width: 320,
	max: 4,
	hilight: false,
	multiple: false, 
	scroll: true, 
	scrollHeight: 300
	})
});