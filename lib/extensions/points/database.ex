use Amnesia

defdatabase Blur.Ext.Points.Database do
  deftable Blur.Ext.Point, [
    { :id, autoincrement },
      :user, :points
  ],
  type: :ordered_set,
  index: [:user] do
  end
end
