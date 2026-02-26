import type { Metadata, Viewport } from "next";
import { Bebas_Neue, Inter } from "next/font/google";
import "./globals.css";
import ServiceWorkerRegister from "@/components/ServiceWorkerRegister";

const bebasNeue = Bebas_Neue({
  weight: "400",
  subsets: ["latin"],
  variable: "--font-bebas",
  display: "swap",
});

const inter = Inter({
  subsets: ["latin"],
  variable: "--font-inter",
  display: "swap",
});

export const metadata: Metadata = {
  title: "Audio Woord",
  description: "Stemoefeningen voor middelbare scholieren – Emma Ducheyne & Emi Catteeuw",
  appleWebApp: {
    capable: true,
    statusBarStyle: "black-translucent",
    title: "Audio Woord",
  },
  icons: {
    apple: "/icons/icon-192.png",
  },
};

export const viewport: Viewport = {
  width: "device-width",
  initialScale: 1,
  maximumScale: 1,
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="nl">
      <body className={`${bebasNeue.variable} ${inter.variable}`}>
        {children}
        <ServiceWorkerRegister />
      </body>
    </html>
  );
}
