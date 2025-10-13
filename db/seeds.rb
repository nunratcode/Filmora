@raw_text = "Аналоговая техника — это мир плёнки, винила, магнитной ленты и тёплого звука. Любители винила ценят
    тёплые частоты пластинок, коллекционеры хранят редкие прессинги, а фотографы на плёнке ищут особую
    текстуру изображений. Ремонт кассетных деках и реставрация усилителей требует терпения и знаний.
    Винтажные радиоприёмники, ручные регуляторы, крутилки (knobs) и метрические приборы — всё это часть
    культуры аналоговой инженерии. Обсуждают выбор плёнки, проявку, баланс громкости, выбор иглы и
    профилактику контактов. Сообщество делится советами по апгрейду, мастер-классы по пайке и обзоры
    ретро-оборудования. Торги, обмены и локальные мастерские помогают сохранять технику в рабочем состоянии."
@words = @raw_text.downcase.gsub(/[—.—,«»:()]/, '').gsub(/  /, ' ').split(' ')


def make_sentence(words, min_words = 6, max_words = 14)
  count = rand(min_words..max_words)
  sent = Array.new(count) { words.sample }.join(' ')
  sent.capitalize + '.'
end

def make_paragraph(words, sentences = 3)
  Array.new(rand(2..sentences)) { make_sentence(words) }.join(' ')
end

def make_body(words, paragraphs = 3)
  Array.new(rand(1..paragraphs)) { make_paragraph(words, 4) }.join("\n\n")
end

['Favorite', 'Like', 'Comment', 'Message', 'Subscription', 'Tag', 'Post', 'User'].each do |const_name|
  if Object.const_defined?(const_name)
    model = Object.const_get(const_name)
    if model.table_exists?
      model.delete_all
      puts "  cleaned #{const_name}"
    end
  end
end  

# теги
fixed_tag_names = [
  'винил',
  'плёнка',
  'кассеты',
  'фотоаппараты',
  'реставрация',
  'ремонт',
  'усилители',
  'радиотехника',
  'ламповый усилитель',
  'плёночная фотография',
  'ретро звук',
  'diy',
  'коллекция',
  'обзор',
  'кассетная культура',
  'audiophile setup',
  'vintage hi-fi',
  'analog vibes',
  'vinyl community',
  'canon',
  'panasonic',
  'sony',
  'pioneer',
  'olimpus'
]

fixed_tags = fixed_tag_names.map do |raw|
  name = raw.strip.downcase
  Tag.find_or_create_by!(name: name) do |t|
    t.fixed = true if t.respond_to?(:fixed=)
  end
end

puts "  tags count: #{Tag.count}"

# делаем юзеров
puts "Creating users..."

# админ
admin = User.find_or_initialize_by(email: 'admin@analogmedia.local')
admin.username ||= 'admin'
admin.admin = true if admin.respond_to?(:admin=)
admin.password ||= 'password'  
admin.save!
puts "  admin: #{admin.email}"

# юзеры
names = [
  ["Alyay", "Nishii"],
  ["Lia", "Aleksandrova"],
  ["Alex", "Plosskiy"],
  ["Jensen", "Acles"],
  ["Misha", "Collins"],
  ["Olga", "Sovunia"],
  ["Maria", "Sileva"],
  ["Julia", "Evgeneva"],
  ["Jared", "Padaleki"],
  ["Victoria", "Semenova"],
]

users = [admin]

names.each_with_index do |(first, last), idx|
  email = "user#{idx}@analogmedia.local"
  u = User.find_or_initialize_by(email: email)
  u.username ||= "#{first.downcase}_#{last.downcase}"
  u.password ||= 'password' 
  u.save!
  users << u
  puts "  user: #{u.email}"
end

puts "  total users: #{User.count}"


# посты
puts "Creating posts..."
posts = []

users.each do |user|
  rand(1..5).times do
    title_candidates = [
      "Обзор оборудования: виниловый проигрыватель",
      "Как выбрать плёнку для портретной съёмки",
      "Ремонт магнитофона: простой чек-лист",
      "Где слушать винил в городе: советы",
      "Тонкости реставрации ламповых усилителей"
    ]
    title = title_candidates.sample
    body = make_body(@words, 4) 
    post = Post.create!(
      user: user,
      title: title,
      body: body,
      published_at: Time.now - rand(1..90).days
    )

    # привязка тегов
    sample_tags = fixed_tags.sample(rand(1..3)).map(&:id)
    post.tag_ids = sample_tags

    upload_path = Rails.root.join('public', 'autoupload', 'posts')
    if defined?(ActiveStorage::Blob) && Dir.exist?(upload_path)
      file = Dir.glob(File.join(upload_path, '*')).sample
      if file && File.exist?(file)
        if post.respond_to?(:image) || post.respond_to?(:images)
          post.image.attach(io: File.open(file), filename: File.basename(file))
          post.save!
        end
      end
    end

    posts << post
    puts "  created post id=#{post.id} title='#{post.title}'"
  end
end
puts "  total posts: #{Post.count}"


# комменты
puts "Creating comments..."
posts.each do |post|
  rand(0..4).times do
    Comment.create!(
  user: users.sample,
  commentable: post,    
  body: make_paragraph(@words, 3)
  )
  end
end
puts "  total comments: #{Comment.count}"

# лайки и закладки
puts "Creating likes and favorites..."
posts.each do |post|
  # лайки
  likers = users.sample(rand(0..users.size))
  likers.each do |u|
    Like.find_or_create_by!(user: u, post: post)
  end

  # закладки
  favorites = users.sample(rand(0..[users.size/2, 1].max))
  favorites.each do |u|
    Favorite.find_or_create_by!(user: u, post: post)
  end
end
puts "  likes: #{Like.count}, favorites: #{Favorite.count}"


#Подписки: каждый подписан на 0..3 других пользователей
puts "Creating subscriptions..."
users.each do |u|
  others = users.reject { |x| x == u }
  others.sample(rand(0..3)).each do |target|
    next if u == target
    Subscription.find_or_create_by!(subscriber: u, subscribed_to: target)
  end
end
puts "  subscriptions: #{Subscription.count}"


# Приватные сообщения: N сообщений между случайными парами
puts "Creating messages..."
20.times do
  a, b = users.sample(2)
  next if a == b
  Message.create!(
    sender: a,
    recipient: b,
    body: make_paragraph(@words, 2),
    created_at: Time.now - rand(1..60).days
  )
end
puts "  messages: #{Message.count}"


puts "=== SEED COMPLETE ==="
puts "Users:      #{User.count}"
puts "Tags:       #{Tag.count}"
puts "Posts:      #{Post.count}"
puts "Comments:   #{Comment.count}"
puts "Likes:      #{Like.count}"
puts "Favorites:  #{Favorite.count}"
puts "Subscriptions: #{Subscription.count}"
puts "Messages:   #{Message.count}"