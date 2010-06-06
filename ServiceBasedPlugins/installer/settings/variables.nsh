; ~+~ ~+~ ~+~ ~+~ ~+~ ~+~ ~+~ ~+~ ~+~ ~+~ ~+~ ~+~ ~+~
; UltraStar Deluxe Un/Installer: Variables
; ~+~ ~+~ ~+~ ~+~ ~+~ ~+~ ~+~ ~+~ ~+~ ~+~ ~+~ ~+~ ~+~

; Product Information:

!define version "1.1a" ; Make sure version is also set in onInit


!define name "UltraStar Deluxe"
!define publisher "USDX Team"
!define homepage "http://www.ultrastardeluxe.org"
!define forum "http://forum.ultrastardeluxe.org"

!define exe "USdx"

!define license "license.txt"

; Icons

!define img_install "install.ico"
!define img_uninstall "uninstall.ico"

; Header Images

!define img_header "header.bmp" ; Header image (150x57)
!define img_side "side.bmp" ; Side image (162x314)

; Registry for Start menu entries:

!define PRODUCT_NAME "${name}"
!define PRODUCT_VERSION "${version}"
!define PRODUCT_PUBLISHER "${publisher}"
!define PRODUCT_WEB_SITE "${homepage}"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${name}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define PRODUCT_STARTMENU_REGVAL "NSIS:StartMenuDir"

; Download URLs for Songs and Themes:

!define download_song1 "http://downloads.sourceforge.net/ultrastardx/usdx_song-dead_smiling_pirates_-_i_18.zip"
!define download_song2 "http://downloads.sourceforge.net/ultrastardx/usdx_song-joshua_morin_-_on_the_run.zip"
!define download_song3 "http://downloads.sourceforge.net/ultrastardx/usdx_song-pornophonique_-_space_-_invaders.zip"
!define download_song4 "http://downloads.sourceforge.net/ultrastardx/usdx_song-steven_dunston_-_northern_star.zip"

!define download_sub1_song1 "http://downloads.sourceforge.net/ultrastardx/usdx_song-jonathan_coulton_-_monkey_shines.zip"
!define download_sub1_song2 "http://downloads.sourceforge.net/ultrastardx/usdx_song-jonathan_coulton_-_i_crush_everything.zip"
!define download_sub1_song3 "http://downloads.sourceforge.net/ultrastardx/usdx_song-jonathan_coulton_-_not_about_you.zip"
!define download_sub1_song4 "http://downloads.sourceforge.net/ultrastardx/usdx_song-jonathan_coulton_-_mr_fancy_pants.zip"
!define download_sub1_song5 "http://downloads.sourceforge.net/ultrastardx/usdx_song-jonathan_coulton_-_big_bad_world_one.zip"
!define download_sub1_song6 "http://downloads.sourceforge.net/ultrastardx/usdx_song-jonathan_coulton_-_flickr.zip"
!define download_sub1_song7 "http://downloads.sourceforge.net/ultrastardx/usdx_song-jonathan_coulton_-_my_beige_bear.zip"
!define download_sub1_song8 "http://downloads.sourceforge.net/ultrastardx/usdx_song-jonathan_coulton_-_the_future_soon.zip"
!define download_sub1_song9 "http://downloads.sourceforge.net/ultrastardx/usdx_song-jonathan_coulton_-_ikea.zip"
!define download_sub1_song10 "http://downloads.sourceforge.net/ultrastardx/usdx_song-jonathan_coulton_-_furry_old_lobster.zip"
!define download_sub1_song11 "http://downloads.sourceforge.net/ultrastardx/usdx_song-jonathan_coulton_-_code_monkey.zip"
!define download_sub1_song12 "http://downloads.sourceforge.net/ultrastardx/usdx_song-jonathan_coulton_-_im_your_moon.zip"
!define download_sub1_song13 "http://downloads.sourceforge.net/ultrastardx/usdx_song-jonathan_coulton_-_first_of_may.zip"
!define download_sub1_song14 "http://downloads.sourceforge.net/ultrastardx/usdx_song-jonathan_coulton_-_dance_soterios_johnson_dance.zip"
!define download_sub1_song15 "http://downloads.sourceforge.net/ultrastardx/usdx_song-jonathan_coulton_-_a_talk_with_george.zip"
!define download_sub1_song16 "http://downloads.sourceforge.net/ultrastardx/usdx_song-jonathan_coulton_-_creepy_doll.zip"
!define download_sub1_song17 "http://downloads.sourceforge.net/ultrastardx/usdx_song-jonathan_coulton_-_that_spells_dna.zip"
!define download_sub1_song18 "http://downloads.sourceforge.net/ultrastardx/usdx_song-jonathan_coulton_-_when_you_go.zip"
!define download_sub1_song19 "http://downloads.sourceforge.net/ultrastardx/usdx_song-jonathan_coulton_-_better.zip"
!define download_sub1_song20 "http://downloads.sourceforge.net/ultrastardx/usdx_song-jonathan_coulton_-_shop_vac.zip"
!define download_sub1_song21 "http://downloads.sourceforge.net/ultrastardx/usdx_song-jonathan_coulton_-_i_feel_fantastic.zip"
!define download_sub1_song22 "http://downloads.sourceforge.net/ultrastardx/usdx_song-jonathan_coulton_-_re-_your_brains.zip"
!define download_sub1_song23 "http://downloads.sourceforge.net/ultrastardx/usdx_song-jonathan_coulton_-_skullcrusher_mountain.zip"
!define download_sub1_song24 "http://downloads.sourceforge.net/ultrastardx/usdx_song-jonathan_coulton_-_chiron_beta_prime.zip"

!define download_theme1 "http://downloads.sourceforge.net/ultrastardx/usdx_skin-orange_by_Skar.zip"
!define download_theme2 "http://downloads.sourceforge.net/ultrastardx/usdx_skin-Streetlight_by_Skar.zip"
!define download_theme3 "http://downloads.sourceforge.net/ultrastardx/usdx_skin-Vistar_by_Skar.zip"
!define download_theme4 "http://downloads.sourceforge.net/ultrastardx/usdx_skin-bluesensationV5_by_Charis.zip"
!define download_theme5 "http://downloads.sourceforge.net/ultrastardx/usdx_skin-WiiStar_by_MasterPhW.zip"
!define download_theme6 "http://downloads.sourceforge.net/ultrastardx/usdx_skin-istar_by_MezzoX.zip"