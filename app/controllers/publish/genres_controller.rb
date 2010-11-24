class Publish::GenresController < PublishController
  layout false

  protected

  def collection
    @genres = case params[:media_type_id].to_i
      when MediaType::CD:  Genre.for_cd
      when MediaType::DVD: Genre.for_dvd
      else Genre.all
    end
  end
end

