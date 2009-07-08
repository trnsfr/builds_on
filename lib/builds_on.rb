module BuildsOn

  def builds_on(name, options={})
    name = name.to_s
    options[:destroy_associations] ||= true
    fields_to_be_skipped_if_blank = [options[:fields_to_be_skipped_if_blank]].flatten.compact

    define_method "#{name}_attributes=" do |new_attributes|
      assoc = send(:"#{name.pluralize}")
      
      # Destroy all previous associations
      #
      assoc.each(&:destroy) if options[:destroy_associations]
      
      # Clear out any attributes that were left blank
      #
      unless fields_to_be_skipped_if_blank.empty?
        new_attributes.delete_if do |e|
          fields_to_be_skipped_if_blank.all?{ |field| e[field].blank? }
        end
      end

      # Build each child
      #
      new_attributes.each{ |data| assoc.build(data) }
    end
  end

end
