require "test_helper"

class JobTest < ActiveSupport::TestCase
  test "should save valid job" do
    job = Job.new(
      title: "Test Job",
      description: "Test description",
      price: 100.00,
      status: :open,
      client: users(:client_one)
    )
    assert job.save, "Failed to save valid job"
  end

  test "should belong to client" do
    job = jobs(:open_job)
    assert_equal users(:client_one), job.client
  end

  test "should optionally belong to worker" do
    job = jobs(:open_job)
    assert_nil job.worker, "Open job should not have worker"

    job_with_worker = jobs(:in_progress_job)
    assert_equal users(:worker_one), job_with_worker.worker
  end

  test "should have chat association" do
    job = jobs(:in_progress_job)
    assert_respond_to job, :chat
  end

  test "should have open status" do
    job = jobs(:open_job)
    assert job.open?, "Job should be open"
    assert_not job.in_progress?, "Job should not be in progress"
    assert_not job.completed?, "Job should not be completed"
  end

  test "should have in_progress status" do
    job = jobs(:in_progress_job)
    assert job.in_progress?, "Job should be in progress"
    assert_not job.open?, "Job should not be open"
    assert_not job.completed?, "Job should not be completed"
  end

  test "should have completed status" do
    job = jobs(:completed_job)
    assert job.completed?, "Job should be completed"
    assert_not job.open?, "Job should not be open"
    assert_not job.in_progress?, "Job should not be in progress"
  end

  test "should change status" do
    job = jobs(:open_job)
    assert job.open?

    job.update(status: :in_progress, worker: users(:worker_one))
    assert job.in_progress?

    job.update(status: :completed)
    assert job.completed?
  end
end
