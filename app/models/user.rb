class User
  include Mongoid::Document
  include ActiveModel::SecurePassword
  

  has_secure_password

  field :email, type: String
  field :email_confirmed, type: Boolean, default: false
  field :password_digest, type: String
  field :confirmation_code, type: String
  field :confirmed_at, type: DateTime
  field :confirmation_sent_at, type: DateTime
  field :reset_password_code, type: String
  field :reset_password_sent_at, type: DateTime
  field :unconfirmed_email, type: String


  validates_presence_of :password_digest, :email
  validates_uniqueness_of :email, case_sensitive: false
  validates_format_of :email, with: /@/

  has_one :profile, inverse_of: :user, autosave: true

  accepts_nested_attributes_for :profile, allow_destroy:true


  before_save :downcase_email
  # before_create :generate_confirmation_instructions
  
	def downcase_email
	  self.email = self.email.delete(' ').downcase
	end

	def generate_confirmation_instructions
	  self.confirmation_code = generate_code
	  self.confirmation_sent_at = Time.now.utc
	end

	def confirmation_code_valid?
	  (self.confirmation_sent_at + 30.days) > Time.now.utc
	end

	def mark_as_confirmed!
	  # self.confirmation_code = nil
    self.confirmation_sent_at = Time.now.utc #sem confirmação
	  self.confirmed_at = Time.now.utc
	  save
	end

  def generate_password_code!
    self.reset_password_code = generate_code
    self.reset_password_sent_at = Time.now.utc
    save!
  end

  def password_code_valid?
    (self.reset_password_sent_at + 4.hours) > Time.now.utc
  end

  def reset_password!(password)
    self.reset_password_code = nil
    self.password = password
    save!
  end

  def confirmation_sent_at_new_email(email)
    self.unconfirmed_email = email
    self.generate_confirmation_instructions
    save
  end

  def update_new_email!
    self.email = self.unconfirmed_email
    self.unconfirmed_email = nil
    self.mark_as_confirmed!
  end


  def self.email_used?(email)
    existing_user = find_by(email: email)

    if existing_user.present?
      return true
    else
      waiting_for_confirmation = find_by(unconfirmed_email: email)
      return waiting_for_confirmation.present? && waiting_for_confirmation.confirmation_code_valid?
    end
  end


  # def send_sms(phone)
  #   account_sid =  ENV['twillio_account_sid']
  #   auth_token =  ENV['twillio_auth_token']
  #   client = Twilio::REST::Client.new(account_sid, auth_token)

  #   message = client.messages.create(
  #       from: ENV['twillio_number'],
  #       to: phone,
  #       body: "Seu código do Desapego: #{self.reset_password_code}"
  #     )

  #   message.status == 'queued'

  # end

  def generate_token
    SecureRandom.hex(10)
  end

  def generate_code
    SecureRandom.random_number(1000..9999).to_s
  end

end
