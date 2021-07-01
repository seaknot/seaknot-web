(use gauche.threads)
(use rfc.http)

(use sxml.tools)

(use makiki)

(use violet)

;;
;; Application
;;

(define (create-page title . children)
  `(html
    (@ (lang "en"))
    (head
     (meta (@ (charset "utf-8")))
     (meta (@ (name "viewport") (content "width=device-width, initial-scale=1, shrink-to-fit=no")))
     (meta (@ (name "description") (content "")))
     (meta (@ (name "author") (content "Mark Otto, Jacob Thornton, and Bootstrap contributors")))
     (title ,title)
     (link (@
            (rel "stylesheet")
            (integrity "sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T")
            (href "https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css")
            (crossorigin "anonymous")))
     (style
         (string-append
          ".bd-placeholder-img {"
          "  font-size: 1.125rem;"
          "  text-anchor: middle;"
          "  -webkit-user-select: none;"
          "  -moz-user-select: none;"
          "  -ms-user-select: none;"
          "  user-select: none;"
          "}"
          "@media (min-width: 768px) {"
          "  .bd-placeholder-img-lg {"
          "    font-size: 3.5rem;"
          "  }"
          "}"
          ))
     (link (@ (rel "stylesheet") (href "/static/starter-template.css"))))
    (body
     (main
      (@ (role "main") (class "container"))
      ,@children)
     (script (@ (src "/static/script.js")) "")
     (script (@
              (src "https://code.jquery.com/jquery-3.3.1.slim.min.js")
              (integrity "sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo")
              (crossorigin "anonymous"))
             "")
     (script (@
              (src "https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js")
              (integrity "sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1")
              (crossorigin "anonymous"))
             "")
     (script (@
              (src "https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js")
              (integrity "sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM")
              (crossorigin "anonymous"))
             "")

     ;; <!-- Global site tag (gtag.js) - Google Analytics -->
     (script (@ (src "https://www.googletagmanager.com/gtag/js?id=UA-158830523-1")) "")
     (script "  window.dataLayer = window.dataLayer || [];"
             "  function gtag(){dataLayer.push(arguments);}"
             "  gtag('js', new Date());"
             "  gtag('config', 'UA-158830523-1');"
             )
     ))
  )



(define (get-random)
  (call-with-input-file "/dev/random"
    (^p
     (let* ((ch (read-char p))
            (result (if (char? ch)
                        (let ((num (char->integer ch)))
                          (thread-sleep! (/ num 1000))
                          num)
                        (x->string ch))))
       result))))

(define (footer)
  `(div (hr (@ (class "my-4")))
        (p "© " (a (@ (href "/")) "Seaknot Studios GK") " 2020-2021.")
        (p "Contact: hello@seaknot.dev | Follow us on Twitter: "
           (a (@ (href "https://twitter.com/seaknotstudios"))
              "@seaknotstudios")
           " | Like us on "
           (a (@ (href "https://www.facebook.com/seaknotstudios/"))
              "our Facebook Page"))
        ))

(define-http-handler "/"
  (^[req app]
    (violet-async
     (^[await]
       (respond/ok
        req
        (cons
         "<!DOCTYPE html>"
         (sxml:sxml->html
          (create-page
           "Seaknot Studios"
           `(h1 (@ (style "text-align: center"))
                (img (@ (src "/static/seaknot-logo-512x256.png")
                        (alt "Seaknot Studios")
                        (style "max-width: 90%"))))
           `(div (@ (class "jumbotron") (style "text-align: center"))
                 (h3 (a (@ (href "/ukiyo/"))
                        "「浮世 (Ukiyo)」"))
                 (img (@ (style "max-width: 100%")
                         (src "/static/ukiyo-image.jpg"))))
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
          (create-page
           "Seaknot Studios"
           `(img (@ (src "/static/ukiyo/ukiyo-poster.jpg")
                    (style "max-width: 90%")
                    (alt "ゲーム「浮世」のポスター")))


           '(div
             (section
              (@ (style "margin-top: 10em;"))
              (h3 "仮想空間を旅するサムライネコの物語")
              (p "和風サイバーパンク仮想世界「UKIYO」は今日も多くのアバターで賑わっていた。")
              (p "しかしそこに小さな異変が。"
                 "なんとゲーム内のフレンドがみんなゲームの世界の住人になってしまったのだ。")
              (p "現実世界に戻るため、サムライネコのカイが仲間とともに仮想空間を旅する。"))

             (section
              (@ (style "margin-top: 10em;"))
              (h3 "メディア")
              (iframe (@ (width "560")
                         (height "315")
                         (src "https://www.youtube.com/embed/SqL2a7NQH84")
                         (title "YouTube video player")
                         (frameborder "0")
                         (allow "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture")
                         (allowfullscreen "allowfullscreen")) ""))

             (section
              (@ (style "margin-top: 10em;"))
              (h3 "概要")
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
                     (tr (td "発売日")(td "2022")))))

           (footer)

           ))))))))

(define-http-handler #/^\/static\// (file-handler))
(define-http-handler "/favicon.ico" (file-handler))
