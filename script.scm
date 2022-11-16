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
                (div (@ (id "indie-game-webring"))
                     (script (@ (type "text/javascript")
                                (src "https://ichigoichie.org/webring/onionring-variables.js"))
                             "")
                     (script (@ (type "text/javascript")
                                (src "https://ichigoichie.org/webring/onionring-widget.js"))
                             ""))
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
		 (p (a (@ (href "https://shueisha-games.com/games/ukiyo/"))
		       "和風サイバーパンクアドベンチャーゲーム「浮世」特設ページ（集英社ゲームズ）"))
                 (p "公式のお知らせはこちら："
                    (a (@ (href "https://www.reddit.com/r/seaknot/collection/24cc4f9b-2f09-457f-9174-8a7d8dbefd2f"))
                       "Seaknot Stuiods News"))
                 (p "その他の掲載情報はこちら：" (a (@ (href "https://www.reddit.com/r/seaknot/"))
                                                    "r/seaknot")))
           (footer)
           ))))))))

(define-http-handler #/^\/ukiyo\/?$/
  (^[req app]
    (respond/redirect req "https://shueisha-games.com/games/ukiyo/" 301)))

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
