(use gauche.threads)
(use rfc.http)

(use sxml.tools)

(add-load-path "./gauche-rheingau/lib/")
(use rheingau)
(rheingau-use makiki)

(add-load-path "./lib/")
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
     (script (@ (src "https://www.googletagmanager.com/gtag/js?id=UA-158830523-1"))
             "  window.dataLayer = window.dataLayer || [];"
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
		   `(h1 (@ (style "text-align: center") (class "display-4"))
                "Seaknot Studios" (br) "シーノットスタジオ")
           `(div (@ (class "jumbotron") (style "text-align: center"))
				 (h2 "#UKIYO")
                 (img (@ (style "max-width: 100%") (src "/static/ukiyo-image.jpg")))
                 (p (@ (class "lead"))
                    "Unreal Engine 4 と Spine を使ってアドベンチャーゲームを作っています。"
					(br)
					"（画像は開発中の画面です。もっとかっこよくなります！）"
					(br)
					"詳しくは "
					(a (@ (href "https://twitter.com/seaknotstudios")) "Twitter")
					" を参照してください。")
                 )
           `(div (hr (@ (class "my-4")))
                 (p "© Seaknot Studios GK 2020.")
                 (p "Contact: hello@seaknot.dev | Follow us on Twitter: "
                    (a (@ (href "https://twitter.com/seaknotstudios"))
                       "@seaknotstudios")
					" | Like us on "
					(a (@ (href "https://www.facebook.com/seaknotstudios/"))
					   "our Facebook Page"))
                 )
           ))))))))

(define-http-handler #/^\/static\// (file-handler))
(define-http-handler "/favicon.ico" (file-handler))
