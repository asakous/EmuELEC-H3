diff -Nur a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
--- a/drivers/media/rc/Kconfig	2016-04-12 12:21:19.000000000 +0200
+++ b/drivers/media/rc/Kconfig	2016-05-07 20:11:02.219989548 +0200
@@ -274,5 +274,15 @@
 
 	   To compile this driver as a module, choose M here: the module will
 	   be called gpio-ir-recv.
+	   
+config IR_SUNXI
+	tristate "SUNXI IR remote control"
+	depends on RC_CORE && !IR_RX_SUNXI
+	depends on ARCH_SUNXI
+	---help---
+	   Say Y if you want to use sunXi internal IR Controller
+
+	   To compile this driver as a module, choose M here: the module will
+	   be called sunxi-cir.
 
 endif #RC_CORE
