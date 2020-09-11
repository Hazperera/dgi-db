class UpdatePharos < ApiUpdater
  def updater
    Genome::OnlineUpdaters::Pharos::Updater.new()
  end

  def should_group_genes?
    true
  end

  def should_group_drugs?
    false
  end

  def should_cleanup_gene_claims?
    false
  end
end
