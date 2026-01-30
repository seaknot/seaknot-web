(use gauche.threads)
(use rfc.http)

(use sxml.tools)

(use makiki)

(use violet)

;;
;; Application
;;

(define (create-page/title title . children)
  `(html
    (@ (lang "en"))
    (head
     (meta (@ (charset "utf-8")))
     (meta (@ (name "viewport") (content "width=device-width, initial-scale=1")))
     (title ,title)
     (link (@ (rel "stylesheet")
              (href "https://cdn.jsdelivr.net/npm/bulma@0.9.0/css/bulma.min.css")))
     (script (@ (src "https://kit.fontawesome.com/515fd4f349.js")
                (crossorigin "anonymous")) ""))
    (body
     ,@children
     (script (@ (src "/static/script.js")) "")
     ,(google-analytics "G-V9X74LTX60")))
  )

(define (google-analytics tag)
  ;; <!-- Global site tag (gtag.js) - Google Analytics -->
  `((script (@ (src ,#"https://www.googletagmanager.com/gtag/js?id=~tag")) "")
    (script "  window.dataLayer = window.dataLayer || [];"
            "  function gtag(){dataLayer.push(arguments);}"
            "  gtag('js', new Date());"
            ,#"  gtag('config', '~|tag|');"
            )))

(define (footer)
  `(footer (@ (class "footer"))
           (div (@ (class "content"))
                (p "© " (a (@ (href "/")) "Seaknot Studios G.K.") " 2020-2025.")
                (p (span (@ (class "icon"))
			 (i (@ (class "far fa-envelope")) ""))
		   "hello@seaknot.dev | Follow us on Twitter: "
                   (a (@ (href "https://twitter.com/seaknotstudios"))
                      "@seaknotstudios")
                   " | Like us on "
                   (a (@ (href "https://www.facebook.com/seaknotstudios/"))
                      "our Facebook Page"))
		(p (span (@ (class "icon"))
			 (i (@ (class "far fa-building")) ""))
		   "シーノット合同会社 〒103-0026 東京都中央区日本橋兜町17番2号 兜町第6葉山ビル4階")
                (div (@ (id "indie-game-webring"))
                     (script (@ (type "text/javascript")
                                (src "https://ichigoichie.org/webring/onionring-variables.js"))
                             "")
                     (script (@ (type "text/javascript")
                                (src "https://ichigoichie.org/webring/onionring-widget.js"))
                             ""))
                )))

(define (static-url req path)
  (if (sys-getenv "LOCALHOST")
      #"/static/~path"
      #"//d1toc4gkz4n0vi.cloudfront.net/~path"))

(define-http-handler "/"
  (^[req app]
    (violet-async
     (^[await]
       (respond/ok
        req
        (cons
         "<!DOCTYPE html>"
         (sxml:sxml->html
          (create-page/title
           "Seaknot Studios"
           `(div (@ (class "container"))
                 (div (@ (class "content"))
                      (h1 (@ (style "text-align: center"))
                          (img (@ (src ,(static-url req "seaknot-logo-512x256.png"))
                                  (alt "Seaknot Studios")
                                  (style "max-width: 90%"))))

                      ((div
                        (@ (class "level"))
                        (div (@ (class "level-item"))
                             (a (@ (href "/games/brass"))
                                (img (@ (src ,(static-url req "library_header.png")))))
                             )))

                      (div (@ (class "notification is-primary is-light"))
			   (h3 (@ (class "title is-3")) "About Seaknot Studios")
			   (p "Seaknot Studios is a small game development studio based in Japan, dedicated to creating engaging and story‑driven adventure games. We developed and released "
			      (a (@ (href "games/brass")) "Brass")
			      ", our first original title, and continue to craft new experiences for players around the world.")
                           (p "News: " (a (@ (href "https://www.reddit.com/r/seaknot/"))
                                                              "r/seaknot")))
                      ,(footer)))
           ))))))))

(define (breadcrumb . path)
  `(nav (@ (class "breadcrumb")
           (aria-label "breadcrumbs"))
        (ul
         ,@(let loop ((path path))
            (if (null? path)
                ()
                (let ((p (car path)))
                  (if (pair? (cdr path))
                      (cons `(li
                                    (a ,(if (cadr path)
                                         `(@ (href ,(cadr p)))
                                         ())
                                    ,(car p)))
                            (loop (cdr path)))
                      `((li (@ (class "is-active"))
                           (a (@ ,@(if (cadr p)
                                   `((href ,(cadr p)))
                                   ())
                                 (aria-current "page"))
                              ,(car p))))
                      )))
            )


         ))

  )


;;
;; Brass
;;
(define (brass-badge req url img alt-text)
  `(div (@ (class "level-item has-text-centered"))
        (a (@ (href ,url)
              (target "_blank") (rel "noopener"))
           (img (@ (src ,(static-url
                          req img))
                   (alt ,alt-text)
                   )))))

(define-http-handler #/^\/games\/brass\/?$/
  (^[req app]
    (violet-async
     (^[await]
       (respond/ok
        req
        (cons
         "<!DOCTYPE html>"
         (sxml:sxml->html
          (create-page/title
           "Brass: a Cozy and Relaxing Adventure Game -Seaknot Studios"

           (breadcrumb '("Seaknot Studios" "/")
                       '("Games" #f))

           `(div (@ (class "container"))
                 (div (@ (class "content"))
                      (p (span (@ (class "tag is-primary")) "2025-10-16"))

                      (h1 (@ (class "is-1 title")) "Brass")
                      (p (@ (class "subtitle"))
                         "A Peaceful, Cozy Adventure")
                      (p (@ (class "subtitle"))
                         "のんびり、ほのぼのアドベンチャーゲーム")

                      (section
                       (@ (class "hero"))
                       (div (@ (class "hero-body"))
                            (img (@ (src ,(static-url req
                                           "Brass_key_art_w_face1920x1080.png"))))

                            ))

                      (h3 (@ (class "title is-3")) "Downloads")

                      (div (@ (class "level"))
                           ,(brass-badge
                             req
                             "https://store.steampowered.com/app/3002060/Brass/"
                             "steam-logo-254w.png" "Steam")
                           ,(brass-badge
                             req
                             "https://www.xbox.com/games/store/brass-a-peaceful-cozy-adventure/9mstlw907dbf"
                             "xbox-logo-200w.png" "Xbox One")
                           ,(brass-badge
                             req
                             "https://www.nintendo.com/us/store/products/brass-switch/"
                             "switch-logo-120w.png" "Nintendo Switch")
                           )
                      (div (@ (class "level") (style "zoom: 150%"))
                           ,(brass-badge
                             req
                             "https://apps.microsoft.com/detail/9mstlw907dbf?referrer=appbadge&mode=direct"
                             "msstore-en-us-dark.svg" "Microsoft Store")
                           ,(brass-badge
                             req
                             "https://apps.apple.com/us/app/brass-peaceful-cozy-adventure/id6756993080"
                             "badge-download-on-the-mac-app-store.svg"
                             "Mac App Store")
                           )

                      (h3 (@ (class "title is-3")) "概要 Overview")

                      (ul (li "タイトル/Title: Brass")
                          (li "価格/Price: $5.99 (700 円)")
                          (li "発売日/Release Date: 2025-04-25")
                          (li "開発者/Developer: シーノットスタジオ/Seaknot Studios")
                          (li "URL: https://seaknot.dev/games/brass"))

                      (h3 (@ (class "title is-3")) "Description")

                      (p "The only post office in a small village in the mountains, the main character of this story, Brass, works here. "
                         "His job is to deliver letters and packages to the local people. "
                         "One day, Brass receives a letter from his grandmother who lives in a town by the sea, and a new adventure begins. ")


                      (h3 (@ (class "title is-3")) "説明")

                      (p "山あいの小さな村にひとつだけの郵便局、この物語の主人公ブラスはここで働いています。村の人たちに手紙や荷物を届けるのが彼の仕事です。"
                         "ある日、ブラスは海沿いの町に住むおばあちゃんから手紙を受け取り、新しい冒険が始まります。")


                      (h3 (@ (class "title is-3"))
                          "リソース Resources")

                      (ul
                       (li (a (@ (href "https://drive.google.com/drive/folders/1QdczugOyb9EcYbHD1rkQ2ZfQysuGY8gr")
                                 (target "_blank") (rel "noopener"))
                              (span (@ (class "icon"))
                                    (i (@ (class "fas fa-file-alt")) ""))
                              " Press Kit (Google Drive)"))
                       (li (a (@ (href "/static/privacy-policy.html")
                                 (target "_blank") (rel "noopener"))
                              (span (@ (class "icon"))
                                    (i (@ (class "fas fa-file-alt")) ""))
                              " Brass Privacy Policy")))

                      ))
           (footer)

           ))))))))

(define-http-handler #/^\/news\/2021\/2021-08-10-ukiyo-bitsummit\/?$/
  (^[req app]
    (violet-async
     (^[await]
       (respond/ok
        req
        (cons
         "<!DOCTYPE html>"
         (sxml:sxml->html
          (create-page/title
           "お知らせ：BitSummit 2021 に浮世を出展 -Seaknot Studios"

           (breadcrumb '("Seaknot Studios" "/")
                       '("News" #f))

           '(section
             (@ (class "section"))
             (p (span (@ (class "tag is-primary")) "2021-08-10"))
             (h1 (@ (class "title"))
                 "BitSummit THE 8th BIT に「浮世」を出展")
             (p "シーノット合同会社は "
                "2021 年 9 月 2 日から 2 日間、京都市勧業館みやこめっせにて開かれるインディゲームの"
                "イベント"
                (a (@ (href "https://bitsummit.org/") (target "_blank"))
                   "BitSummit THE 8th BIT")
                "に自社で開発中のゲーム"
                (a (@ (href "https://seaknot.dev/ukiyo/") (target "_blank"))
                   "「浮世 (Ukiyo)」")
                "を出展します。")
             (p "イベント会場では「浮世」のデモ版を展示し、来場いただいた方々にその場で遊んでいただけます。"
                "ご来場の際にはぜひ「浮世」のブースにお立ち寄りください。"
                )
             )
           (footer)

           ))))))))

(define-http-handler #/^\/static\//
  (let ((handler (file-handler)))
    (^[req app]
      (parameterize ((file-mime-type
                      (^[path]
                        (rxmatch-case path
                                      [#/\.svg$/ () "image/svg+xml"]
                                      [else ()])) ; fallback
                      ))
        (handler req app)))))

(define-http-handler "/favicon.ico" (file-handler))

;;;;; Joke

(define-http-handler "/redirect-sakusaku"
  (^[req app]
    (violet-async
     (^[await]
       (respond/redirect req "https://www.lotte.co.jp/products/brand/koala/")
       #;(respond/redirect req "https://www.kabaya.co.jp/catalog/sakupan/")))))
