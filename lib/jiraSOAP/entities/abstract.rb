module JIRA

# Does no initialization itself, subclassing classes need to
# initialize attributes themselves.
# @abstract
class DynamicEntity
  # @return [String] usually holds a numerical value but for consistency with
  #  with id's from custom fields this attribute is always a String
  attr_accessor :id
end

# @abstract
class NamedEntity < JIRA::DynamicEntity
  # @return [String] a plain language name
  attr_accessor :name

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag)
    @id, @name = frag.nodes ['id', :to_s], ['name', :to_s]
  end
end

# @abstract
class DescribedEntity < JIRA::NamedEntity
  # @return [String] usually a short blurb
  attr_accessor :description

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag)
    @id, @name, @description =
      frag.nodes ['id', :to_s], ['name', :to_s], ['description', :to_s]
  end
end

# Represents a scheme used by the server. Not very useful for the sake of the
# API; a more useful case might be if you wanted to emulate the server's
# behaviour.
# @abstract
class Scheme < JIRA::DescribedEntity
  # @return [String]
  def type
    self.class.to_s
  end

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag = nil)
    super frag unless frag.nil?
  end
end

# A common base for most issue properties.
# @abstract
class IssueProperty < JIRA::DescribedEntity
  # @return [URL] A NSURL on MacRuby and a URI::HTTP object in CRuby
  attr_accessor :icon

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag)
    @id, @name, @description, @icon =
      frag.nodes( ['id',          :to_s],
                  ['name',        :to_s],
                  ['description', :to_s],
                  ['icon',        :to_url] )
  end
end

end
