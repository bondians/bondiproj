// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(
	function () {
		$('a.closeEl').bind('click', toggleContent);
		$('div.groupWrapper').Sortable(
			{
				accept: 'groupItem',
				helperclass: 'sortHelper',
				activeclass : 	'sortableactive',
				hoverclass : 	'sortablehover',
				handle: 'tr.cssAlternating1',
				tolerance: 'pointer',
				onChange : function(ser)
				{
				},
				onStart : function()
				{
					$.iAutoscroller.start(this, document.getElementsByTagName('body'));
				},
				onStop : function()
				{
					$.iAutoscroller.stop();
				}
			}
		);
	}
);

function toggleAll(name)
{
  boxes = document.getElementsByClassName(name);
  for (i = 0; i < boxes.length; i++)
    if (!boxes[i].disabled) {
        boxes[i].checked = !boxes[i].checked ;
    }
}
