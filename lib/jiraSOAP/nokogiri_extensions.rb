##
# Monkey (Freedom) patches to Nokogiri
module Nokogiri::XML::Element

  # @return [Fixnum]
  def to_i
    content.to_i
  end

  # @return [Time,nil]
  def to_iso_date
    return if (temp = content).empty?
    Time.iso8601 temp
  end

  ##
  # Parses non-strict date strings into Time objects.
  #
  # @return [Time,nil]
  def to_natural_date
    return if (temp = content).empty?
    Time.new temp
  end

  ##
  # We assume that the boolean is encoded as as string, because that
  # how JIRA is doing right now, but the XML schema allows a boolean
  # to be encoded as 0/1 numbers instead.
  #
  # @return [Boolean]
  def to_boolean
    content == 'true' # || content == 1
  end

  # @return [URI::HTTP,NSURL,nil]
  def to_url
    return if (temp = content).empty?
    JIRA.url_class.send JIRA.url_init_method, temp
  end

  ##
  # This is a bit naive, but should be sufficient for its purpose.
  #
  # @return [Array(String,String,String),nil]
  def to_color_triple
    return if (temp = content).empty?
    temp.match(/#(..)(..)(..)/).captures
  end
  alias_method :to_colour_triple, :to_color_triple

  ##
  # Ideally this method will return an array of strings, but this
  # may not always be the case.
  def contents_of_children
    children.map { |val| val.content }
  end

  # @param [Class] klass the JIRA object you want to make
  def children_as_object klass
    klass.new_with_xml self
  end

  # @param [Class] klass the object you want an array of
  # @return [Array] an array of klass objects
  def children_as_objects klass
    children.map { |node| klass.new_with_xml node }
  end
end
