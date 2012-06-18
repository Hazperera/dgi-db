class LookupFamilies
  class << self
    def find_gene_groups_for_families(family_names)
      families = Array(family_names)
      raise "Please specify at least one family name" unless families.size > 0

      results = families.inject({}) do |hash, family|
        hash[family] = DataModel::GeneAlternateName.includes(gene: [:gene_groups]).where{
          nomenclature.eq("human_readable_name") & alternate_name.eq(family)
        }.map{|gan| gan.gene.gene_groups }.flatten.uniq
        hash
      end

      structs = []
      results.flatten.each_slice(2) do |family|
        structs += family[-1].map{|x| OpenStruct.new(family: family[0], gene_group: x)}
      end
      structs
    end

    def get_uniq_category_names_with_counts
      if Rails.cache.exist?("unique_category_names_with_counts")
        Rails.cache.fetch("unique_category_names_with_counts")
      else
        #map to structs is a hack to allow these objects to be cached.
        #you can't marshal a singleton instance of a model class which
        #is what this select creates
        category_names  = DataModel::GeneAlternateName.where{ nomenclature.eq("human_readable_name") }
          .joins{ gene.gene_groups }.group{ alternate_name }
          .select{ count(gene.gene_groups.id) }.select{ alternate_name }
          .map{|x| OpenStruct.new(alternate_name: x.alternate_name,count: x.count )}
        Rails.cache.write("unique_category_names_with_counts", category_names, expires_in: 3.hours)
        category_names
      end
    end
  end
end


