// logo.typ — Logotipo "PRESUPOSICIONALISMO" en Typst puro (sin SVG).
// Origen: Logo.svg (viewBox 628 × 153). Adorno rediseñado: gotas con casquete tangente y cola curva (cola = 0,5).
//
//   #import "logo.typ": logo, simbolo, paleta
//   #logo(width: 6cm)                         // hereda el color del texto
//   #logo(width: 6cm, color: paleta.rojo)
//   #simbolo(width: 2cm)                      // las 7 gotas solas
//   #simbolo(width: 1cm, capas: 2)            // 3 gotas: para favicon / tamaños muy pequeños

#let paleta = (
  navy: rgb("#1a1a2e"),
  rojo: rgb("#b5392b"),
  crema: rgb("#f4f0e8"),
  gris: rgb("#5c5c6e"),
)

#let texto(u) = {
  let P(x, y) = (x * u, y * u)
  (
    curve.move(P(4.1, 152)),
    curve.line(P(11.3, 152)),
    curve.line(P(11.3, 125.2)),
    curve.line(P(20.4, 125.2)),
    curve.cubic(P(29.7, 125.2), P(32.2, 122.6), P(32.2, 113.5)),
    curve.line(P(32.2, 95.2)),
    curve.cubic(P(32.2, 86.2), P(29.7, 83.5), P(20.4, 83.5)),
    curve.line(P(4.1, 83.5)),
    curve.close(mode: "straight"),
    curve.move(P(11.3, 119.2)),
    curve.line(P(11.3, 89.5)),
    curve.line(P(19.1, 89.5)),
    curve.cubic(P(24.4, 89.5), P(25, 91.2), P(25, 96.4)),
    curve.line(P(25, 112.3)),
    curve.cubic(P(25, 117.5), P(24.4, 119.2), P(19.1, 119.2)),
    curve.close(mode: "straight"),
    curve.move(P(68.2, 128.3)),
    curve.cubic(P(68.2, 121.6), P(66.7, 118.5), P(62, 117.3)),
    curve.cubic(P(66.7, 116.1), P(68.2, 113), P(68.2, 106.2)),
    curve.line(P(68.2, 95.2)),
    curve.cubic(P(68.2, 86.2), P(65.6, 83.5), P(56.2, 83.5)),
    curve.line(P(39.3, 83.5)),
    curve.line(P(39.3, 152)),
    curve.line(P(46.5, 152)),
    curve.line(P(46.5, 120.2)),
    curve.line(P(54.4, 120.2)),
    curve.cubic(P(59.9, 120.2), P(60.9, 122.5), P(60.9, 127.8)),
    curve.line(P(60.9, 141.4)),
    curve.cubic(P(60.9, 145.7), P(60.9, 149.8), P(61.9, 152)),
    curve.line(P(69.6, 152)),
    curve.cubic(P(68.5, 148.6), P(68.2, 144.4), P(68.2, 140)),
    curve.close(mode: "straight"),
    curve.move(P(60.9, 107.2)),
    curve.cubic(P(60.9, 112.4), P(60.4, 114.2), P(55.1, 114.2)),
    curve.line(P(46.5, 114.2)),
    curve.line(P(46.5, 89.4)),
    curve.line(P(55.1, 89.4)),
    curve.cubic(P(60.5, 89.4), P(60.9, 91.1), P(60.9, 96.4)),
    curve.close(mode: "straight"),
    curve.move(P(84.8, 89.4)),
    curve.line(P(99.6, 89.4)),
    curve.line(P(99.6, 83.4)),
    curve.line(P(77.5, 83.4)),
    curve.line(P(77.5, 151.9)),
    curve.line(P(99.6, 151.9)),
    curve.line(P(99.6, 145.9)),
    curve.line(P(84.8, 145.9)),
    curve.line(P(84.8, 118.9)),
    curve.line(P(97.4, 118.9)),
    curve.line(P(97.4, 113.1)),
    curve.line(P(84.8, 113.1)),
    curve.close(mode: "straight"),
    curve.move(P(126, 139.4)),
    curve.cubic(P(126, 144.7), P(125.5, 146.4), P(120.3, 146.4)),
    curve.line(P(118.2, 146.4)),
    curve.cubic(P(112.9, 146.4), P(112.5, 144.7), P(112.5, 139.4)),
    curve.line(P(112.5, 127.1)),
    curve.line(P(105.6, 127.1)),
    curve.line(P(105.6, 140.7)),
    curve.cubic(P(105.6, 149.7), P(108.2, 152.4), P(117.5, 152.4)),
    curve.line(P(121.5, 152.4)),
    curve.cubic(P(130.8, 152.4), P(133.2, 149.7), P(133.2, 140.7)),
    curve.line(P(133.2, 133.6)),
    curve.cubic(P(133.2, 125.1), P(131.5, 122.3), P(122.1, 114.7)),
    curve.cubic(P(114.2, 108.2), P(112.9, 106.2), P(112.9, 99.8)),
    curve.line(P(112.9, 95.7)),
    curve.cubic(P(112.9, 90.5), P(113.3, 88.9), P(118.6, 88.9)),
    curve.line(P(120.7, 88.9)),
    curve.cubic(P(126, 88.9), P(126.4, 90.5), P(126.4, 95.8)),
    curve.line(P(126.4, 106.2)),
    curve.line(P(133.2, 106.2)),
    curve.line(P(133.2, 94.5)),
    curve.cubic(P(133.2, 85.5), P(130.8, 82.9), P(121.5, 82.9)),
    curve.line(P(117.5, 82.9)),
    curve.cubic(P(108.2, 82.9), P(105.6, 85.5), P(105.6, 94.5)),
    curve.line(P(105.6, 99.9)),
    curve.cubic(P(105.6, 108.4), P(107.4, 111.1), P(116.7, 118.8)),
    curve.cubic(P(124.7, 125.3), P(126, 127.2), P(126, 133.7)),
    curve.close(mode: "straight"),
    curve.move(P(148.8, 83.3)),
    curve.line(P(141.6, 83.3)),
    curve.line(P(141.6, 140.6)),
    curve.cubic(P(141.6, 149.6), P(144, 152.3), P(153.5, 152.3)),
    curve.line(P(158.2, 152.3)),
    curve.cubic(P(167.6, 152.3), P(170.1, 149.6), P(170.1, 140.6)),
    curve.line(P(170.1, 83.3)),
    curve.line(P(163.2, 83.3)),
    curve.line(P(163.2, 139.4)),
    curve.cubic(P(163.2, 144.7), P(162.8, 146.3), P(157.4, 146.3)),
    curve.line(P(154.6, 146.3)),
    curve.cubic(P(149.3, 146.3), P(148.8, 144.7), P(148.8, 139.4)),
    curve.close(mode: "straight"),
    curve.move(P(179.7, 151.8)),
    curve.line(P(187, 151.8)),
    curve.line(P(187, 125)),
    curve.line(P(196, 125)),
    curve.cubic(P(205.3, 125), P(207.9, 122.3), P(207.9, 113.2)),
    curve.line(P(207.9, 94.9)),
    curve.cubic(P(207.9, 85.9), P(205.3, 83.3), P(196, 83.3)),
    curve.line(P(179.7, 83.3)),
    curve.close(mode: "straight"),
    curve.move(P(187, 119)),
    curve.line(P(187, 89.3)),
    curve.line(P(194.8, 89.3)),
    curve.cubic(P(200.1, 89.3), P(200.6, 90.9), P(200.6, 96.2)),
    curve.line(P(200.6, 112.1)),
    curve.cubic(P(200.6, 117.2), P(200.1, 119), P(194.8, 119)),
    curve.close(mode: "straight"),
    curve.move(P(214.2, 140.6)),
    curve.cubic(P(214.2, 149.6), P(216.8, 152.3), P(226.2, 152.3)),
    curve.line(P(231.3, 152.3)),
    curve.cubic(P(240.7, 152.3), P(243.3, 149.6), P(243.3, 140.6)),
    curve.line(P(243.3, 94.4)),
    curve.cubic(P(243.3, 85.4), P(240.7, 82.8), P(231.3, 82.8)),
    curve.line(P(226.2, 82.8)),
    curve.cubic(P(216.8, 82.8), P(214.2, 85.4), P(214.2, 94.4)),
    curve.close(mode: "straight"),
    curve.move(P(235.9, 139.4)),
    curve.cubic(P(235.9, 144.7), P(235.6, 146.3), P(230.2, 146.3)),
    curve.line(P(227.3, 146.3)),
    curve.cubic(P(221.9, 146.3), P(221.6, 144.7), P(221.6, 139.4)),
    curve.line(P(221.6, 95.7)),
    curve.cubic(P(221.6, 90.5), P(221.9, 88.8), P(227.3, 88.8)),
    curve.line(P(230.2, 88.8)),
    curve.cubic(P(235.6, 88.8), P(235.9, 90.5), P(235.9, 95.7)),
    curve.close(mode: "straight"),
    curve.move(P(271.4, 139.4)),
    curve.cubic(P(271.4, 144.7), P(271, 146.4), P(265.7, 146.4)),
    curve.line(P(263.6, 146.4)),
    curve.cubic(P(258.3, 146.4), P(257.9, 144.7), P(257.9, 139.4)),
    curve.line(P(257.9, 127.1)),
    curve.line(P(251.1, 127.1)),
    curve.line(P(251.1, 140.7)),
    curve.cubic(P(251.1, 149.7), P(253.6, 152.4), P(262.9, 152.4)),
    curve.line(P(266.9, 152.4)),
    curve.cubic(P(276.2, 152.4), P(278.6, 149.7), P(278.6, 140.7)),
    curve.line(P(278.6, 133.6)),
    curve.cubic(P(278.6, 125.1), P(276.9, 122.3), P(267.5, 114.7)),
    curve.cubic(P(259.6, 108.2), P(258.3, 106.2), P(258.3, 99.8)),
    curve.line(P(258.3, 95.7)),
    curve.cubic(P(258.3, 90.5), P(258.8, 88.9), P(264, 88.9)),
    curve.line(P(266.1, 88.9)),
    curve.cubic(P(271.4, 88.9), P(271.8, 90.5), P(271.8, 95.8)),
    curve.line(P(271.8, 106.2)),
    curve.line(P(278.6, 106.2)),
    curve.line(P(278.6, 94.5)),
    curve.cubic(P(278.6, 85.5), P(276.2, 82.9), P(266.9, 82.9)),
    curve.line(P(262.9, 82.9)),
    curve.cubic(P(253.6, 82.9), P(251.1, 85.5), P(251.1, 94.5)),
    curve.line(P(251.1, 99.9)),
    curve.cubic(P(251.1, 108.4), P(252.8, 111.1), P(262.2, 118.8)),
    curve.cubic(P(270.1, 125.3), P(271.4, 127.2), P(271.4, 133.7)),
    curve.close(mode: "straight"),
    curve.move(P(287.2, 151.8)),
    curve.line(P(294.5, 151.8)),
    curve.line(P(294.5, 83.3)),
    curve.line(P(287.2, 83.3)),
    curve.close(mode: "straight"),
    curve.move(P(311.1, 95.7)),
    curve.cubic(P(311.1, 90.5), P(311.4, 88.8), P(316.8, 88.8)),
    curve.line(P(319.6, 88.8)),
    curve.cubic(P(325, 88.8), P(325.4, 90.5), P(325.4, 95.7)),
    curve.line(P(325.4, 107.9)),
    curve.line(P(332.3, 107.9)),
    curve.line(P(332.3, 94.5)),
    curve.cubic(P(332.3, 85.5), P(329.9, 82.8), P(320.4, 82.8)),
    curve.line(P(315.7, 82.8)),
    curve.cubic(P(306.2, 82.8), P(303.7, 85.5), P(303.7, 94.5)),
    curve.line(P(303.7, 140.7)),
    curve.cubic(P(303.7, 149.7), P(306.2, 152.3), P(315.7, 152.3)),
    curve.line(P(320.4, 152.3)),
    curve.cubic(P(329.9, 152.3), P(332.3, 149.7), P(332.3, 140.7)),
    curve.line(P(332.3, 124.3)),
    curve.line(P(325.4, 124.3)),
    curve.line(P(325.4, 139.4)),
    curve.cubic(P(325.4, 144.7), P(325, 146.3), P(319.6, 146.3)),
    curve.line(P(316.8, 146.3)),
    curve.cubic(P(311.4, 146.3), P(311.1, 144.7), P(311.1, 139.4)),
    curve.close(mode: "straight"),
    curve.move(P(341.4, 151.7)),
    curve.line(P(348.7, 151.7)),
    curve.line(P(348.7, 83.3)),
    curve.line(P(341.4, 83.3)),
    curve.close(mode: "straight"),
    curve.move(P(357.9, 140.5)),
    curve.cubic(P(357.9, 149.5), P(360.4, 152.1), P(369.9, 152.1)),
    curve.line(P(374.9, 152.1)),
    curve.cubic(P(384.4, 152.1), P(386.9, 149.5), P(386.9, 140.5)),
    curve.line(P(386.9, 94.3)),
    curve.cubic(P(386.9, 85.3), P(384.4, 82.7), P(374.9, 82.7)),
    curve.line(P(369.9, 82.7)),
    curve.cubic(P(360.4, 82.7), P(357.9, 85.3), P(357.9, 94.3)),
    curve.close(mode: "straight"),
    curve.move(P(379.5, 139.3)),
    curve.cubic(P(379.5, 144.5), P(379.2, 146.2), P(373.8, 146.2)),
    curve.line(P(371, 146.2)),
    curve.cubic(P(365.6, 146.2), P(365.3, 144.5), P(365.3, 139.3)),
    curve.line(P(365.3, 95.6)),
    curve.cubic(P(365.3, 90.3), P(365.6, 88.7), P(371, 88.7)),
    curve.line(P(373.8, 88.7)),
    curve.cubic(P(379.2, 88.7), P(379.5, 90.3), P(379.5, 95.6)),
    curve.close(mode: "straight"),
    curve.move(P(417, 151.7)),
    curve.line(P(425.2, 151.7)),
    curve.line(P(425.2, 83.3)),
    curve.line(P(418.8, 83.3)),
    curve.line(P(418.8, 125.3)),
    curve.cubic(P(418.8, 129.6), P(419, 133.4), P(419.1, 137.2)),
    curve.cubic(P(418.4, 133.4), P(417.7, 129.6), P(416.6, 125.4)),
    curve.line(P(405.5, 83.3)),
    curve.line(P(396.1, 83.3)),
    curve.line(P(396.1, 151.7)),
    curve.line(P(402.4, 151.7)),
    curve.line(P(402.4, 106.8)),
    curve.cubic(P(402.4, 102.5), P(402.3, 98.7), P(402.2, 95)),
    curve.cubic(P(402.8, 98.7), P(403.6, 102.5), P(404.7, 106.6)),
    curve.close(mode: "straight"),
    curve.move(P(455.8, 151.7)),
    curve.line(P(463.1, 151.7)),
    curve.line(P(452.4, 83.3)),
    curve.line(P(442.4, 83.3)),
    curve.line(P(431.6, 151.7)),
    curve.line(P(438.1, 151.7)),
    curve.line(P(439.9, 140.7)),
    curve.line(P(453.9, 140.7)),
    curve.close(mode: "straight"),
    curve.move(P(443.1, 120.2)),
    curve.cubic(P(445.1, 107.8), P(446.3, 97), P(446.9, 89.1)),
    curve.cubic(P(447.7, 97), P(449, 107.7), P(450.9, 120.2)),
    curve.line(P(453.1, 134.7)),
    curve.line(P(440.8, 134.7)),
    curve.close(mode: "straight"),
    curve.move(P(469.9, 151.7)),
    curve.line(P(490.3, 151.7)),
    curve.line(P(490.3, 145.7)),
    curve.line(P(477.2, 145.7)),
    curve.line(P(477.2, 83.2)),
    curve.line(P(469.9, 83.2)),
    curve.close(mode: "straight"),
    curve.move(P(496.3, 151.7)),
    curve.line(P(503.5, 151.7)),
    curve.line(P(503.5, 83.2)),
    curve.line(P(496.3, 83.2)),
    curve.close(mode: "straight"),
    curve.move(P(532.3, 139.3)),
    curve.cubic(P(532.3, 144.6), P(531.9, 146.2), P(526.6, 146.2)),
    curve.line(P(524.5, 146.2)),
    curve.cubic(P(519.2, 146.2), P(518.8, 144.6), P(518.8, 139.3)),
    curve.line(P(518.8, 126.9)),
    curve.line(P(512, 126.9)),
    curve.line(P(512, 140.5)),
    curve.cubic(P(512, 149.5), P(514.5, 152.2), P(523.9, 152.2)),
    curve.line(P(527.8, 152.2)),
    curve.cubic(P(537.2, 152.2), P(539.6, 149.5), P(539.6, 140.5)),
    curve.line(P(539.6, 133.4)),
    curve.cubic(P(539.6, 124.9), P(537.8, 122.2), P(528.5, 114.5)),
    curve.cubic(P(520.6, 108.1), P(519.2, 106), P(519.2, 99.6)),
    curve.line(P(519.2, 95.5)),
    curve.cubic(P(519.2, 90.4), P(519.7, 88.7), P(525, 88.7)),
    curve.line(P(527.1, 88.7)),
    curve.cubic(P(532.3, 88.7), P(532.8, 90.4), P(532.8, 95.6)),
    curve.line(P(532.8, 106)),
    curve.line(P(539.6, 106)),
    curve.line(P(539.6, 94.4)),
    curve.cubic(P(539.6, 85.4), P(537.2, 82.7), P(527.8, 82.7)),
    curve.line(P(523.9, 82.7)),
    curve.cubic(P(514.5, 82.7), P(512, 85.4), P(512, 94.4)),
    curve.line(P(512, 99.7)),
    curve.cubic(P(512, 108.3), P(513.8, 110.9), P(523.1, 118.6)),
    curve.cubic(P(531, 125.1), P(532.3, 127), P(532.3, 133.5)),
    curve.close(mode: "straight"),
    curve.move(P(578.9, 105.7)),
    curve.cubic(P(579.5, 102.7), P(579.9, 98.3), P(580.5, 94.7)),
    curve.cubic(P(580.4, 98.2), P(580.2, 102.6), P(580.2, 105.7)),
    curve.line(P(580.2, 151.7)),
    curve.line(P(587.4, 151.7)),
    curve.line(P(587.4, 83.2)),
    curve.line(P(576.5, 83.2)),
    curve.line(P(568.7, 129)),
    curve.cubic(P(568.3, 131.9), P(567.9, 135.3), P(567.7, 138.6)),
    curve.cubic(P(567.4, 135.3), P(567.1, 131.9), P(566.6, 129)),
    curve.line(P(558.8, 83.2)),
    curve.line(P(548, 83.2)),
    curve.line(P(548, 151.7)),
    curve.line(P(554.3, 151.7)),
    curve.line(P(554.3, 105.7)),
    curve.cubic(P(554.3, 102.6), P(554.2, 97.5), P(554.1, 93.7)),
    curve.cubic(P(554.5, 97.5), P(555.2, 102.4), P(555.8, 105.7)),
    curve.line(P(564.2, 151.7)),
    curve.line(P(570.7, 151.7)),
    curve.close(mode: "straight"),
    curve.move(P(596.5, 140.6)),
    curve.cubic(P(596.5, 149.6), P(599, 152.2), P(608.5, 152.2)),
    curve.line(P(613.5, 152.2)),
    curve.cubic(P(623, 152.2), P(625.5, 149.6), P(625.5, 140.6)),
    curve.line(P(625.5, 94.4)),
    curve.cubic(P(625.5, 85.4), P(623, 82.7), P(613.5, 82.7)),
    curve.line(P(608.5, 82.7)),
    curve.cubic(P(599, 82.7), P(596.5, 85.4), P(596.5, 94.4)),
    curve.close(mode: "straight"),
    curve.move(P(618.1, 139.3)),
    curve.cubic(P(618.1, 144.6), P(617.8, 146.2), P(612.4, 146.2)),
    curve.line(P(609.6, 146.2)),
    curve.cubic(P(604.2, 146.2), P(603.8, 144.6), P(603.8, 139.3)),
    curve.line(P(603.8, 95.7)),
    curve.cubic(P(603.8, 90.4), P(604.2, 88.7), P(609.6, 88.7)),
    curve.line(P(612.4, 88.7)),
    curve.cubic(P(617.8, 88.7), P(618.1, 90.4), P(618.1, 95.7)),
    curve.close(mode: "straight"),
  )
}

// Gota con casquete circular y cola curva.
// cx: eje · tip: y de la punta · h: alto total · w: ancho · rot: giro alrededor de la punta
// cola: 0 = flancos rectos (cono) · 1 = el ancho cae como una parábola (cola cóncava, punta en cúspide)
#let gota(cx, tip, h, w, u, rot: 0deg, cola: 0.5) = {
  let r = w / 2
  let d = h - r
  // Punto donde la cola se une al casquete, resuelto para que la unión sea tangente (sin quiebre)
  let bj = calc.asin(r / d)
  for _ in range(12) {
    bj = calc.atan((1 + cola) * r * calc.cos(bj) / (d - r * calc.sin(bj)))
  }
  let (jx, jy) = (r * calc.cos(bj), -d + r * calc.sin(bj))
  let P(p) = {
    let (x, y) = p
    ((cx + x * calc.cos(rot) - y * calc.sin(rot)) * u, (tip + x * calc.sin(rot) + y * calc.cos(rot)) * u)
  }
  let arco(f0, f1) = {
    let k = 4 / 3 * calc.tan((f1 - f0) / 4)
    let pt(f) = (r * calc.cos(f), -d - r * calc.sin(f))
    let dir(f) = (-calc.sin(f), -calc.cos(f))
    let (x0, y0) = pt(f0)
    let (x1, y1) = pt(f1)
    let (dx0, dy0) = dir(f0)
    let (dx1, dy1) = dir(f1)
    curve.cubic(P((x0 + k * r * dx0, y0 + k * r * dy0)), P((x1 - k * r * dx1, y1 - k * r * dy1)), P((x1, y1)))
  }
  let paso = (180deg + 2 * bj) / 3
  let arcos = range(3).map(i => arco(-bj + paso * i, -bj + paso * (i + 1)))
  // controles de la cola (lado derecho, de la unión hacia la punta)
  let c1 = (jx * (2 / 3 - cola / 3), jy * 2 / 3)
  let c2 = (jx * (1 / 3 - cola / 3), jy / 3)
  (
    curve.move(P((0, 0))),
    curve.cubic(P(c2), P(c1), P((jx, jy))),
    ..arcos,
    curve.cubic(P((-c1.at(0), c1.at(1))), P((-c2.at(0), c2.at(1))), P((0, 0))),
    curve.close(mode: "straight"),
  )
}


// Gotas del adorno: `capas` = 4 → 7 gotas (centro + 3 pares) · 3 → 5 · 2 → 3
#let _pitch = 19.2
#let _gotas(capas) = {
  let hs = (73.3, 49.2, 28.5, 18.2)
  let tips = (73.3, 61.3, 50.9, 45.7)
  let ws = (13.7, 8.0, 7.4, 6.8)
  let out = ()
  for i in range(capas) {
    let signos = if i == 0 { (1,) } else { (-1, 1) }
    for s in signos {
      out.push((dx: s * i * _pitch, tip: tips.at(i), h: hs.at(i), w: ws.at(i)))
    }
  }
  out
}

#let _color(color) = if color == auto { text.fill } else { color }
#let _trazo(c, u) = stroke(paint: c, thickness: 1 * u, cap: "round", join: "round")

#let logo(width: 150pt, color: auto, cola: 0.5, hueco: 26) = context {
  let c = _color(color)
  let u = width / 628
  let cx0 = 315
  let gs = _gotas(4)
  let ext = calc.max(..gs.map(g => calc.abs(g.dx) + g.w / 2))
  let izq = cx0 - ext - hueco
  let der = cx0 + ext + hueco
  box(width: width, height: 153 * u, {
    place(top + left, curve(fill: c, stroke: _trazo(c, u), ..texto(u)))
    place(top + left, curve(stroke: _trazo(c, u), curve.move((4 * u, 64.4 * u)), curve.line((izq * u, 64.4 * u))))
    place(top + left, curve(stroke: _trazo(c, u), curve.move((der * u, 64.4 * u)), curve.line((626 * u, 64.4 * u))))
    for g in gs {
      place(top + left, curve(fill: c, stroke: _trazo(c, u), ..gota(cx0 + g.dx, g.tip, g.h, g.w, u, cola: cola)))
    }
  })
}

// Solo el adorno. `width` es el ancho de las 7 gotas; con menos capas el recuadro se mantiene.
#let simbolo(width: 2cm, color: auto, capas: 4, cola: 0.5) = context {
  let c = _color(color)
  let u = width / 126
  box(width: width, height: 76 * u, {
    for g in _gotas(capas) {
      place(top + left, curve(fill: c, stroke: _trazo(c, u), ..gota(63 + g.dx, 1 + g.tip, g.h, g.w, u, cola: cola)))
    }
  })
}
