module JobsHelper
  def workflow_step_display(job)
    stepString = "["
    job.workflow_steps_simple.each  do |wf|  
      stepString << (wf.completed ? wf.name.slice(0..0).downcase : wf.name.slice(0..0))
    end
    stepString << "]"
  end

  def index_accordion_color(j)
    if j.task == 43 then 
      return "AccordionPanelTab"
    end

    colorTag = case j.task.name 
    when  /Design/  then "AccordionPanelTabD"
    when /Copy/     then "AccordionPanelTabC"
    when  /Press/   then "AccordionPanelTabP"
    when /Binde?ry/ then "AccordionPanelTabB"
    when  /Ship/    then "AccordionPanelTabS"
    when  /Other/   then "AccordionPanelTabO"
    else "AccordionPanelTab"
    end
    return colorTag
    #   return "AccordionPanelTab"
  end
  
  def last_completed_task_category(job)
    
  end
  
  def next_incomplete_task_category(job)
    
  end 
  
end
 

