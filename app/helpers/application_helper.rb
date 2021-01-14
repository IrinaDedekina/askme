module ApplicationHelper
  def user_avatar(user)
    if user.avatar_url.present?
      user.avatar_url
    else
      asset_path "avatar.jpg"
    end
  end

  def fa_icon(icon_class)
    content_tag "span", "", class: "fa fa-#{icon_class}"
  end

  def inclination(number, one, few, many)
    remainder10 = number % 10
    remainder100 = number % 100

    if remainder100 >= 11 && remainder100 <= 14
        return many
    end

    if remainder10 == 1
      return one
    end

    if remainder10 > 4 || remainder10 == 0
      return many
    end

    few
  end
end
