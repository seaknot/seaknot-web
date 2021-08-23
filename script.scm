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
     ,(google-analytics "UA-158830523-1")))
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
                (p "© " (a (@ (href "/")) "Seaknot Studios G.K.") " 2020-2021.")
                (p "Contact: hello@seaknot.dev | Follow us on Twitter: "
                   (a (@ (href "https://twitter.com/seaknotstudios"))
                      "@seaknotstudios")
                   " | Like us on "
                   (a (@ (href "https://www.facebook.com/seaknotstudios/"))
                      "our Facebook Page"))
                )))

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
           `(h1 (@ (style "text-align: center"))
                (img (@ (src "/static/seaknot-logo-512x256.png")
                        (alt "Seaknot Studios")
                        (style "max-width: 90%"))))

           '(div (@ (class "notification is-primary is-light"))
                 "お知らせ："
                 (a (@ (href "/news/2021/2021-08-10-ukiyo-bitsummit/"))
                    "BitSummit THE 8th BIT に「浮世」を出展 (2021-08-10)"))

           `(section (@ (class "hero")
                        (style "text-align: center"))
                     (div (@ (class "hero-body"))
                          (p (@ (class "title"))
                             (a (@ (href "/ukiyo/"))
                                "「浮世 (Ukiyo)」"))
                          (img (@ (style "max-width: 100%")
                                  (src "/static/ukiyo-image.jpg")))))
           (footer)
           ))))))))

(define-http-handler #/^\/ukiyo\/?$/
  (^[req app]
    (violet-async
     (^[await]
       (respond/ok
        req
        (cons
         "<!DOCTYPE html>"
         (sxml:sxml->html
          (create-page/title
           "浮世 Ukiyo -Seaknot Studios"

           (breadcrumb '("Seaknot Studios" "/")
                       '("Games" #f))

           `(img (@ (src "/static/ukiyo/ukiyo-poster.jpg")
                    (style "max-width: 90%")
                    (alt "ゲーム「浮世」のポスター")))


           '(div
             (section
              (@ (class "section") (style "margin-top: 10em;"))
              (div (@ (class "container"))
                   (h3 (@ (class "title")) "仮想空間を旅するサムライネコの物語")
                   (p "和風サイバーパンク仮想世界「UKIYO」は今日も多くのアバターで賑わっていた。")
                   (p "しかしそこに小さな異変が。"
                      "なんとゲーム内のフレンドがみんなゲームの世界の住人になってしまったのだ。")
                   (p "現実世界に戻るため、サムライネコのカイが仲間とともに仮想空間を旅する。")))

             (section
              (@ (class "section") (style "margin-top: 10em;"))
              (div (@ (class "container"))
                   (h3 (@ (class "title")) "メディア")
                   (iframe (@ (style "width:560px;height:315px;max-width:100%")
                              (src "https://www.youtube.com/embed/uaVUWUti4_Q")
                              (title "YouTube video player")
                              (frameborder "0")
                              (allow "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture")
                              (allowfullscreen "allowfullscreen")) "")))

             (section
              (@ (class "section") (style "margin-top: 10em;"))
              (div (@ (class "container"))
                   (h3 (@ (class "title")) "概要")
                   (table (@ (class "table"))
                          (tr (td "ゲームジャンル")
                              (td "和風サイバーパンクアドベンチャー"))
                          (tr (td "制作")
                              (td (a (@ (href "/"))
                                     "シーノットスタジオ")
                                  "、"
                                  (a (@ (href "https://freakydesign.com/")
                                        (target "_blank")
                                        (rel "noopener noreferrer"))
                                     "フリーキーデザイン")))
                          (tr (td "対応プラットフォーム")
                              (td "PC、Xbox One、他"))
                          (tr (td "マルチプレイ対応")
                              (td "シングルプレイ"))
                          (tr (td "発売日")(td "2022"))))))

           (footer)

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

(define-http-handler #/^\/static\// (file-handler))
(define-http-handler "/favicon.ico" (file-handler))
