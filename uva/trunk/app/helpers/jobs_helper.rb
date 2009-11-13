module JobsHelper
  def workflow_step_display(job)
    stepString = "["
    job.workflow_steps_simple.each  do |wf|  
      stepString << (wf.completed ? wf.name.slice(0..0).downcase : wf.name.slice(0..0))
    end
    stepString << "]"
  end
end
