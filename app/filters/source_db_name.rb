class SourceDbName
  include Filter

  def initialize(source_db_name)
    @source_db_name = source_db_name
  end

  def cache_key
    "source.db_name.#{@source_db_name}"
  end

  def axis
    :sources
  end

  def resolve
    Set.new DataModel::Source.where(source_db_name: @source_db_name)
      .joins(:interaction_claims)
      .pluck('interaction_claims.id')
  end
end