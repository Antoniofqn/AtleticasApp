# frozen_string_literal: true

##
# View helpers that are used across the application for many different concepts.
#
module ApplicationHelper
  ##
  # Raise invalid scope error
  #
  def invalid_scope
    raise StandardError.new, I18n.t('application.errors.application_query.invalid_scope')
  end

  ##
  # Raise invalid values error
  #
  def invalid_values
    raise StandardError.new, I18n.t('application.errors.application_query.invalid_values')
  end

  ##
  # Raise invalid keys error
  #
  def invalid_keys
    raise StandardError.new, I18n.t('application.errors.application_query.invalid_keys')
  end

  ##
  # Raise invalid keys/values size error
  #
  def invalid_keys_values_size
    raise StandardError.new, I18n.t('application.errors.application_query.invalid_keys_values_size')
  end

  ##
  # Raise error if string contain sql command
  #
  def sql_injection_warning
    raise StandardError.new, I18n.t('application.errors.application_query.sql_injection_warning')
  end

  ##
  # Raise error if client given invalid operator
  #
  def invalid_conjunctor
    raise StandardError.new, I18n.t('application.errors.application_query.invalid_conjunctor')
  end

  ##
  # Encrypt string using a deterministic encryption
  #
  def encrypt_string(string = '')
    BCrypt::Engine.hash_secret(string, '$2a$12$HYlQqobo9Q7TkHDEblIV6O')
  end

  ##
  # Creates fake cookie
  #
  def fake_cookie
    SecureRandom.hex
  end

  ##
  # Generates a random number sequence
  #
  def random_number_sequence(size = 6)
    return '' if size.blank? || size <= 0

    result = String.new
    first_step_counter = (size / 10).ceil
    last_step_counter = size % 10
    first_step_counter.times do
      result << (0..9).to_a.sample(10).join
    end
    result << (0..9).to_a.sample(last_step_counter).join
    result
  end

  ##
  # Get model from controller class name
  #
  def model_from_controller(controller = '')
    return nil if controller&.to_s.blank?

    controller = controller.to_s
    controller.split('::').each do |str|
      if str.include?('Controller')
        controller = str
        break
      end
    end
    controller.remove('Controller').singularize.safe_constantize
  end

  ##
  # Get model by controller
  #
  def model_from_active_relation(active_relation = '')
    return nil if active_relation&.to_s.blank?

    active_relation.to_s.split('::').first.constantize
  end

  ##
  # Check if string has SQL commmand
  #
  def string_has_sql_command?(str = '')
    return false if str.blank?

    (sql_commands_list & str.split(' ').map(&:upcase)).present?
  end

  ##
  # Parse a date
  #
  def parse_date(date, date_format = '%d/%m/%Y', fallback: nil)
    return fallback if date.blank? || date_format.blank?

    Date.strptime(date, date_format)
  rescue => e
    nil
  end

  ##
  # Parse money in "10.100,10" format
  #
  def parse_money(amount, fallback: nil)
    return fallback unless amount.present?

    amount.to_s.remove('.', ' ').gsub(',', '.').to_f
  rescue StantardError
    fallback
  end

  ##
  # Standardize fields to clear database ruids
  #
  def standardize_field(str = '')
    return str if str.blank?

    str.to_s.strip.delete('^0-9')
  end

  ##
  # Mask for email
  #
  def masked_email(email = '')
    return email if email.blank?

    [masked_username(email.split('@').first), masked_domain(email.split('@').last)].join('@')
  end

  ##
  # Get masked username
  #
  def masked_username(username = '')
    return username if username.blank?

    if username.size > 2
      username.first << '*' * (username.size - 2) << username.last
    else
      '*' * username.size
    end
  end

  ##
  # Get masked domain
  #
  def masked_domain(domain = '')
    return domain if domain.blank?

    domain_masked = String.new
    domain.split('.').slice(0..-2).each do |domain_part|
      domain_masked << masked_username(domain_part) << '.'
    end
    domain_masked << domain.split('.').last
  end

  ##
  # Get masked phone
  #
  def masked_phone(phone = '')
    return phone if phone.blank?

    format_phone(phone).slice(0..-3).split('').map { |c| %w[( ) -].include?(c) ? c : '*' }.join << phone.last(2)
  end

  ##
  # Array with string placard
  #
  def placard(str = '')
    return [] if str.blank?

    str.size.times.map do
      tmp_str = str
      str = str.slice(1..-1) << str[0]
      tmp_str
    end
  end

  ##
  # Format brazilian phone number
  #
  def format_phone(phone = '')
    return phone if phone.blank?

    phone = standardize_field(phone)
    breakpoint = - 5 + phone.size
    case phone.size
    when 8..9
      phone = "#{phone.slice(0..breakpoint)}-#{phone.slice((breakpoint + 1)..-1)}"
    when 10..11
      phone = "(#{phone.slice(0..1)}) #{phone.slice(2..breakpoint)}-#{phone.slice((breakpoint + 1)..-1)}"
    end
    phone
  end

  ##
  # Deliver a presigned URL to the API endpoints so that a React uploader can
  # upload and create or replace an image.
  #
  def presigned_aws_url(file_name)
    name = "#{encrypt_string(file_name)}#{SecureRandom.hex}#{Time.zone.now.to_i}".parameterize
    name += file_name.split('.').last.present? ? ".#{file_name.split('.').last}" : ''
    s3 = Aws::S3::Resource.new(region: ENV['S3_REGION'])
    obj = s3.bucket(ENV['S3_BUCKET_NAME']).object(name)
    obj.presigned_url(:put, acl: 'public-read', expires_in: 3600 * 24)
  end

  ##
  # Pick only the component of the URL necessary for return through the API.
  # Called by the presigned_aws_url method defined above.
  #
  def compose_aws_url(url)
    "#{url.scheme}://#{url.host}#{url.path}?#{url.query}"
  end

  ##
  # Send in any model to the avatar_url helper. If the model has an e-mail
  # field, prepare to use that for a gravatar_url call. But prefer sending back
  # the avatar_url property on the entity if it is present.
  #
  def avatar_url(entity)
    entity.avatar_url.presence || ''
  end

  ##
  # Send the url or blank, if not ok
  #
  def photo_url(field)
    field.presence || ''
  end

  ##
  # As the user always have an avatar_url, even if its not uploaded, check
  # if the photo was uploaded by the user to enable removal.
  #
  def uploaded_avatar?(entity)
    entity.avatar_url.present?
  end

  ##
  # Return list of all sql commands
  #
  def sql_commands_list
    [
      '!=', '=', 'ABORT', 'ALTER AGGREGATE', 'ALTER CONVERSION', 'ALTER DATABASE', 'ALTER DOMAIN', 'ALTER FUNCTION',
      'ALTER GROUP', 'ALTER INDEX', 'ALTER LANGUAGE', 'ALTER OPERATOR CLASS', 'ALTER OPERATOR', 'ALTER SCHEMA',
      'ALTER SEQUENCE', 'ALTER TABLE', 'ALTER TABLESPACE', 'ALTER TRIGGER', 'ALTER TYPE', 'ALTER USER', 'ANALYZE',
      'AND', 'BEGIN', 'CASE', 'CHECKPOINT', 'CLOSE', 'CLUSTER', 'COMMENT', 'COMMIT', 'COPY', 'CREATE AGGREGATE',
      'CREATE CAST', 'CREATE CONSTRAINT TRIGGER', 'CREATE CONVERSION', 'CREATE DATABASE', 'CREATE DOMAIN',
      'CREATE FUNCTION', 'CREATE GROUP', 'CREATE INDEX', 'CREATE LANGUAGE', 'CREATE OPERATOR CLASS', 'CREATE OPERATOR',
      'CREATE RULE', 'CREATE SCHEMA', 'CREATE SEQUENCE', 'CREATE TABLE AS', 'CREATE TABLE', 'CREATE TABLESPACE',
      'CREATE TRIGGER', 'CREATE TYPE', 'CREATE USER', 'CREATE VIEW', 'DEALLOCATE', 'DECLARE', 'DELETE', 'DROP AGGREGATE',
      'DROP CAST', 'DROP CONVERSION', 'DROP DATABASE', 'DROP DOMAIN', 'DROP FUNCTION', 'DROP GROUP', 'DROP INDEX',
      'DROP LANGUAGE', 'DROP OPERATOR CLASS', 'DROP OPERATOR', 'DROP RULE', 'DROP SCHEMA', 'DROP SEQUENCE', 'DROP TABLE',
      'DROP TABLESPACE', 'DROP TRIGGER', 'DROP TYPE', 'DROP USER', 'DROP VIEW', 'END', 'EXECUTE', 'EXPLAIN', 'FETCH',
      'GRANT', 'ILIKE', 'INSERT', 'IS', 'LIKE', 'LISTEN', 'LOAD', 'LOCK', 'MOVE', 'NOT', 'NOTIFY', 'NULL', 'OR',
      'PREPARE', 'REINDEX', 'RELEASE SAVEPOINT', 'RESET', 'REVOKE', 'ROLLBACK TO SAVEPOINT', 'ROLLBACK', 'SAVEPOINT',
      'SELECT INTO', 'SELECT', 'SET CONSTRAINTS', 'SET SESSION AUTHORIZATION', 'SET TRANSACTION', 'SET', 'SHOW',
      'START TRANSACTION', 'SUBSTR', 'THEN', 'TRUNCATE', 'UNLISTEN', 'UPDATE', 'VACUUM', 'WHERE'
    ]
  end
end
