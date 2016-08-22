class DomainValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # The shortest possible domain name something like Google's g.cn, which is four characters long
    # The longest possible domain name, as per RFC 1035, RFC 1123, and RFC 2181 is 253 characters
    valid = if value.blank? || value.length < 4 || value.length > 253 || value.include?('/') || !value.include?('.')
              false
            else
              begin
                URI.parse('http://' + value).kind_of?(URI::HTTP)
              rescue URI::InvalidURIError
                false
              end
            end
    record.errors.add(attribute, I18n.t('errors.bad_domain_name')) unless valid
  end
end
