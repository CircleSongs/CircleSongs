User.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
Language.create!([
  {name: "English"},
  {name: "Spanish"},
  {name: "Katchwa"}
])
Password.create!([
  {name: "Restricted Songs", value: "foo"}
])
ChordForm.create!([
  {chord: "Am7", fingering: "{\"chord\": [[1, \"x\"], [2, 1], [3, \"x\"], [4, 3], [5, 0], [6, \"x\"] ] }"}
])
Song.create!([
  {title: "Hotel California", alternate_title: "Most Popular Song In The World", composer: "The Eagles", lyrics: "On a dark desert highway, cool wind in my hair...", translation: "En un calle oscuro...", chords: "[Dm]On a dark desert [A]highway, [Em]cool wind in my hair...", description: nil, composer_url: nil, image_data: nil},
  {title: "El Condor Pasa", alternate_title: nil, composer: nil, lyrics: nil, translation: nil, chords: nil, description: nil, composer_url: nil, image_data: nil},
  {title: "Taki Taki Muyki", alternate_title: nil, composer: nil, lyrics: nil, translation: nil, chords: nil, description: nil, composer_url: nil, image_data: nil},
  {title: "Restricted Song", alternate_title: nil, composer: nil, lyrics: nil, translation: nil, chords: nil, description: nil, composer_url: nil, image_data: nil}
])
Category.create!([
  {name: "Popular", restricted: false},
  {name: "Traditional", restricted: false},
  {name: "Sacred", restricted: false},
  {name: "Restricted", restricted: true}
])
Recording.create!([
  {title: "Sound Cloud", description: nil, url: "http://soundclound.com/hotel-california", song_id: "d4634495-7f04-5004-aa39-b5780884c8e8", embedded_player: nil, reported: nil, position: nil},
  {title: "The Eagles Website", description: nil, url: "http://theeagles.com/hotel-california", song_id: "d4634495-7f04-5004-aa39-b5780884c8e8", embedded_player: nil, reported: nil, position: nil}
])
Song::HABTM_Languages.create!([
  {language_id: "e22b305e-8764-50bf-adcd-a46305b77992", song_id: "d4634495-7f04-5004-aa39-b5780884c8e8"},
  {language_id: "88cd409e-6dd2-50bf-b0e4-996cbedeb9fe", song_id: "6d70ea03-cf17-59b1-b082-f0af813450ca"},
  {language_id: "c95c98d2-720b-58ec-84ab-8c03c7d0a0f3", song_id: "6d70ea03-cf17-59b1-b082-f0af813450ca"},
  {language_id: "c95c98d2-720b-58ec-84ab-8c03c7d0a0f3", song_id: "1d586e94-b465-5e01-83fb-76a96ce03329"},
  {language_id: "e22b305e-8764-50bf-adcd-a46305b77992", song_id: "aa984c89-6e63-590b-85b9-20217c66d6e8"}
])
Song::HABTM_Categories.create!([
  {category_id: "3d204e1b-0ead-5789-8991-17668c21fda4", song_id: "d4634495-7f04-5004-aa39-b5780884c8e8"},
  {category_id: "13f10774-cb0d-506e-86a6-779ddd8051f4", song_id: "6d70ea03-cf17-59b1-b082-f0af813450ca"},
  {category_id: "a09b7644-512e-5dd3-be95-f030806062d8", song_id: "1d586e94-b465-5e01-83fb-76a96ce03329"},
  {category_id: "aa984c89-6e63-590b-85b9-20217c66d6e8", song_id: "aa984c89-6e63-590b-85b9-20217c66d6e8"}
])
Category::HABTM_Songs.create!([
  {category_id: "3d204e1b-0ead-5789-8991-17668c21fda4", song_id: "d4634495-7f04-5004-aa39-b5780884c8e8"},
  {category_id: "13f10774-cb0d-506e-86a6-779ddd8051f4", song_id: "6d70ea03-cf17-59b1-b082-f0af813450ca"},
  {category_id: "a09b7644-512e-5dd3-be95-f030806062d8", song_id: "1d586e94-b465-5e01-83fb-76a96ce03329"},
  {category_id: "aa984c89-6e63-590b-85b9-20217c66d6e8", song_id: "aa984c89-6e63-590b-85b9-20217c66d6e8"}
])
