require 'genome/online_updater'

module Genome; module Importers; module Cgi;
  class NewCgi
    attr_reader :file_path, :source
    def initialize(file_path)
      @file_path = file_path
    end

    def get_version
      source_db_version = Date.today.strftime("%d-%B-%Y")
      @new_version = source_db_version
    end

    def import
      remove_existing_source
      create_new_source
      create_interaction_claims
    end

    private
    def remove_existing_source
      Utils::Database.delete_source('CGI')
    end

    def create_new_source
      @source ||= DataModel::Source.create(
          {
              base_url: 'http://https://www.cancergenomeinterpreter.org/biomarkers',
              site_url: 'https://www.cancergenomeinterpreter.org/',
              citation: 'https://www.cancergenomeinterpreter.org/',
              source_db_version:  get_version,
              source_type_id: DataModel::SourceType.INTERACTION,
              source_db_name: 'CGI',
              full_name: 'Cancer Genome Interpreter'
          }
      )
    end

    def create_interaction_claims
      CSV.parse(file_path, :headers => true, :col_sep => '\t') do |row|
        gene_claim = create_gene_claim(row['Gene'], 'CGI Gene Name')

        if row['Drug'].include? ','
          combination_drug_name = row['Drug']
          combination_drug_name.scan(/[a-zA-Z0-9]+/).each do |individual_drug_name|
            drug_claim = create_drug_claim(individual_drug_name, individual_drug_name, 'CGI Drug Name')
            interaction_claim = create_interaction_claim(gene_claim, drug_claim)
            create_interaction_claim_attribute(interaction_claim, 'combination therapy', combination_drug_name)
            create_interaction_claim_attribute(interaction_claim, 'Drug family', row['Drug family'])
            add_interaction_claim_publications(interaction_claim, row['Source'])
            end
        else
          drug_claim = create_drug_claim(row['Drug'], row['Drug'], 'CGI Drug Name')
          interaction_claim = create_interaction_claim(gene_claim, drug_claim)
          add_interaction_claim_publications(interaction_claim, row['Source'])
          create_interaction_claim_attribute(interaction_claim, 'Drug family', row['Drug family'])
        end
      end
    end

    def add_interaction_claim_publications(interaction_claim, source_string)
      source_string.split(':').last do |pmid|
        create_interaction_claim_publications(interaction_claim, pmid)
      end
    end
  end
end; end; end