require 'httparty'
require 'json'
require 'lib/kele/roadmap.rb'

class Kele
  include HTTParty
  include Roadmap
  def initialize(email, password)
    response = self.class.post(api_url("sessions"), body: {"email": email, "password": password})
    raise "Invalid email or password" if response.code == 404
    @auth_token = response["auth_token"]
  end

  def get_me
    response = self.class.get(api_url('users/me'), headers: { "authorization" => @auth_token })
    @user_data = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get(api_url("mentors/#{mentor_id}/student_availability"), headers: { "authorization" => @auth_token })
    @mentor_availability = JSON.parse(response.body)
  end

  def get_messages(page)
    response = self.class.get(base_api_endpoint("message_threads?page=#{page}"), headers: { "authorization" => @auth_token })
    @get_messages = JSON.parse(response.body)
  end

  def create_message(recipient_id, subject, message)
    response = self.class.post(base_api_endpoint("messages"), body: { "user_id": id, "recipient_id": recipient_id, "subject": subject, "stripped-text": message }, headers: { "authorization" => @auth_token })
    puts response
  end

  def create_submissions(checkpoint_id, assignment_branch, assignment_commit_link, comment)
    response = self.class.post(base_api_endpoint("checkpoint_submissions"), body: { "checkpoint_id": checkpoint_id, "assignment_branch": assignment_branch, "assignment_commit_link": assignment_commit_link, "comment": comment }, headers: { "authorization" => @auth_token })
    puts response
  end
  
  private

  def api_url(endpoint)
    "https://www.bloc.io/api/v1/#{endpoint}"
  end

end
