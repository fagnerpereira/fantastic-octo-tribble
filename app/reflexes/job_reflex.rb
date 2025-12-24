class JobReflex < ApplicationReflex
  def accept
    job = Job.find(element.dataset[:job_id])
    if job.open?
      job.update(worker: current_user, status: :in_progress)
      chat = Chat.create(job: job)

      # Broadcast to other users to remove the job from the feed
      cable_ready.broadcast.remove(selector: dom_id(job))

      # Redirect the current user to the chat
      morph :nothing
      redirect_to chat_path(chat)
    end
  end
end
