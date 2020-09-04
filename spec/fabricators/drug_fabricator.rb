Fabricator(:drug, class_name: 'DataModel::Drug') do
  name { sequence(:pref_name) { |i| "Drug Name ##{i}" } }
  concept_id { sequence(:concept_id) { |i| "chembl:CHEMBL#{i}" } }
end

Fabricator(:drug_claim, class_name: 'DataModel::DrugClaim') do
  name { sequence(:name) { |i| "Drug Claim ##{i}" } }
  source
  nomenclature { |attrs| "#{attrs[:source].source_db_name} drug claim name" }
  primary_name { sequence(:primary_name) { |i| "Drug claim primary name ##{i}" } }
end

Fabricator(:drug_claim_alias, class_name: 'DataModel::DrugClaimAlias') do |f|
  f.alias { sequence(:alias) { |i| "Drug Claim Alias ##{i}" } }
  f.nomenclature { sequence(:nomenclature) { |i| "Drug Claim Alias nomenclature ##{i}" } }
end

Fabricator(:drug_claim_attribute, class_name: 'DataModel::DrugClaimAttribute') do
  name { sequence(:name) { |i| "Drug Claim Attribute Name ##{i}" } }
  value { sequence(:value) { |i| "Drug Claim Attribute Value ##{i}" } }
end

Fabricator(:drug_claim_type, class_name: 'DataModel::DrugClaimType') do
  type { ['antineoplastic', ''].sample }
end

Fabricator(:drug_alias, class_name: 'DataModel::DrugAlias') do |f|
  f.alias { sequence(:alias) { |i| "Drug Alias Name ##{i}" } }
  drug
end

Fabricator( :drug_attribute, class_name: 'DataModel::DrugAttribute') do
  drug
  name { sequence(:name) {|i| "Drug attribute name ##{i}"}}
  value { sequence(:value) { |i| "Drug attribute value ##{i}"}}
end

