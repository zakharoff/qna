ThinkingSphinx::Index.define :question, with: :active_record do
  # fields
  indexes title, sortable: true
  indexes body
  indexes author.email, sortable: true

  # attributes
  has author_id, created_at, updated_at
end
