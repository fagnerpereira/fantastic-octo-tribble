require "test_helper"

class JobsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @worker = users(:worker_one)
    @client = users(:client_one)
  end

  # Index Tests (Worker View)
  test "should get index as worker" do
    log_in_as(@worker)
    get jobs_path
    assert_response :success
  end

  test "should show open jobs in index" do
    log_in_as(@worker)
    get jobs_path
    assert_response :success
    # Optionally check that job title appears
    assert_match jobs(:open_job).title, response.body if jobs(:open_job).title.present?
  end

  test "should not get index as client" do
    log_in_as(@client)
    get jobs_path
    assert_redirected_to root_path
    assert_equal "Acesso não autorizado.", flash[:alert]
  end

  test "should not get index when not logged in" do
    get jobs_path
    assert_redirected_to login_path
  end

  # New Tests (Client View)
  test "should get new as client" do
    log_in_as(@client)
    get new_job_path
    assert_response :success
  end

  test "should not get new as worker" do
    log_in_as(@worker)
    get new_job_path
    assert_redirected_to root_path
    assert_equal "Acesso não autorizado.", flash[:alert]
  end

  test "should not get new when not logged in" do
    get new_job_path
    assert_redirected_to login_path
  end

  # Create Tests
  test "should create job as client" do
    log_in_as(@client)
    assert_difference("Job.count", 1) do
      post jobs_path, params: {
        job: {
          title: "Novo Serviço",
          description: "Descrição do serviço",
          price: 250.00
        }
      }
    end
    assert_redirected_to dashboard_path
    assert_equal "Serviço publicado com sucesso!", flash[:notice]
  end

  test "created job should belong to current client" do
    log_in_as(@client)
    post jobs_path, params: {
      job: {
        title: "Test Job",
        description: "Test Description",
        price: 100.00
      }
    }
    job = Job.last
    assert_equal @client.id, job.client_id
  end

  test "should not create job as worker" do
    log_in_as(@worker)
    assert_no_difference("Job.count") do
      post jobs_path, params: {
        job: {
          title: "Novo Serviço",
          description: "Descrição",
          price: 250.00
        }
      }
    end
    assert_redirected_to root_path
  end

  test "should not create job when not logged in" do
    assert_no_difference("Job.count") do
      post jobs_path, params: {
        job: {
          title: "Novo Serviço",
          description: "Descrição",
          price: 250.00
        }
      }
    end
    assert_redirected_to login_path
  end

  # Show Tests
  test "should show job as worker" do
    log_in_as(@worker)
    get job_path(jobs(:open_job))
    assert_response :success
  end

  test "should not show job as client" do
    log_in_as(@client)
    get job_path(jobs(:open_job))
    assert_redirected_to root_path
    assert_equal "Acesso não autorizado.", flash[:alert]
  end

  test "should not show job when not logged in" do
    get job_path(jobs(:open_job))
    assert_redirected_to login_path
  end
end
