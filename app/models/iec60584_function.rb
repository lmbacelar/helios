class Iec60584Function < TransferFunction
  include RetryMethods

  self.inheritance_column = nil
  
  #
  # TYPES
  #
  TYPES = %w{ B C E J K N R S T }

  validates :name, presence: true, uniqueness: true
  validates :type, presence: true, inclusion: { in: TYPES }

  #
  # REFERENCE DIRECT FUNCTION (t => emf)
  # 
  def emfr t, range_check = true
    EMF_EQUATIONS[type].each do |equation|
      range = range_check ? equation[:range] : equation[:open_range]
      if range.include? t
        result  = equation[:c].each_with_index.map{ |c,i| c*t**i }.reduce(:+)
        result += equation[:a][0] * Math.exp(equation[:a][1] * (t - equation[:a][2])**2) if equation[:a]
        return result
      end
    end
    nil
  end

  #
  # REFERENCE INVERSE FUNCTION (emf => t)
  # 
  MAX_ITERATIONS = 10
  MAX_ERROR      = 1e-3

  def t90r emf
    return 0 if emf == 0
    t = t90_approximation emf
    return nil unless t
    MAX_ITERATIONS.times do
      emf_calc = emfr(t, false)
      emf_aux = emf_calc * 1.01
      t_aux = t90_approximation emf_aux, false
      slope = (emf_calc - emf_aux) / (t - t_aux)
      break if (emf_calc - emf).abs < slope * MAX_ERROR
      t -= (emf_calc - emf) / slope
    end
    t
  end

  #
  # EMF_DEVIATION FUNCTIONS
  #
  def emfdev t90
    (a3*t90**3 + a2*t90**2 + a1*t90 + a0) if t90
  end
  
  #
  # T90 / EMF FUNCTIONS
  #
  def t90 emf
    t = t90r emf
    t90r emf - emfdev(t) if t
  end
  
  def emf t90
    # UNIMPLEMENTED
    nil
  end

  #
  # VALID TEMPERATURE RANGES
  #
  def range
    case type
    when 'B' then    0.0..1820.0
    when 'C' then    0.0..2320.0
    when 'E' then -270.0..1000.0
    when 'J' then -210.0..1200.0
    when 'K' then -270.0..1372.0
    when 'N' then -270.0..1300.0
    when 'R' then  -50.0..1768.0
    when 'S' then  -50.0..1768.0
    when 'T' then -270.0..400.0
    end
  end

private
  def t90_approximation emf, range_check = true
    T90_EQUATIONS[type].each do |equation|
      range = range_check ? equation[:range] : equation[:open_range]
      return equation[:d].each_with_index.map{ |d,i| d*emf**i }.reduce(:+) if range.include? emf
    end
    nil
  end

  #
  # DIRECT FUNCTION COEFFICIENTS
  #
  EMF_EQUATIONS  = 
    { 
      'B' => [ { open_range: -1.0/0..630.615,
                      range: 0.0..630.615,
                          c: [  0.000000000000e+00, -0.246508183460e-03,  0.590404211710e-05,
                               -0.132579316360e-08,  0.156682919010e-11, -0.169445292400e-14,
                                0.629903470940e-18 ] },
               { open_range: 630.615..1.0/0,
                      range: 630.615..1820.0,
                          c: [ -0.389381686210e+01,  0.285717474700e-01, -0.848851047850e-04,
                                0.157852801640e-06, -0.168353448640e-09,  0.111097940130e-12,
                               -0.445154310330e-16,  0.989756408210e-20, -0.937913302890e-24 ] } ],
    
      'C' => [ { open_range: -1.0/0..1.0/0,
                      range: 0.0..2320.0,
                          c: [ -3.109077870000e-04,  1.338547130000e-02,  1.226236040000e-05,
                               -1.050537530000e-08,  3.613274640000e-12, -4.990804550000e-16,
                                6.434651840000e-22 ] } ],

      'E' => [ { open_range: -1.0/0..0.0,
                      range: -270.0..0.0,
                          c: [  0.000000000000e+00,  0.586655087080e-01,  0.454109771240e-04,
                               -0.779980486860e-06, -0.258001608430e-07, -0.594525830570e-09,
                               -0.932140586670e-11, -0.102876055340e-12, -0.803701236210e-15,
                               -0.439794973910e-17, -0.164147763550e-19, -0.396736195160e-22,
                               -0.558273287210e-25, -0.346578420130e-28 ] },
               { open_range: 0.0..1.0/0,
                      range: 0.0..1000.0,
                          c: [  0.000000000000e+00,  0.586655087100e-01,  0.450322755820e-04,
                                0.289084072120e-07, -0.330568966520e-09,  0.650244032700e-12,
                               -0.191974955040e-15, -0.125366004970e-17,  0.214892175690e-20,
                               -0.143880417820e-23,  0.359608994810e-27 ] } ],

      'J' => [ { open_range: -1.0/0..760.0,
                      range: -210.0..760.0,
                          c: [  0.000000000000e+00,  0.503811878150e-01,  0.304758369300e-04,
                               -0.856810657200e-07,  0.132281952950e-09, -0.170529583370e-12,
                                0.209480906970e-15, -0.125383953360e-18,  0.156317256970e-22 ] },
               { open_range: 760.0..1.0/0,
                      range: 760.0..1200.0,
                          c: [  0.296456256810e+03, -0.149761277860e+01,  0.317871039240e-02,
                               -0.318476867010e-05,  0.157208190040e-08, -0.306913690560e-12 ] } ],

      'K' => [ { open_range: -1.0/0..0.0,
                      range: -270.0..0.0,
                          c: [  0.000000000000e+00,  0.394501280250e-01,  0.236223735980e-04,
                               -0.328589067840e-06, -0.499048287770e-08, -0.675090591730e-10,
                               -0.574103274280e-12, -0.310888728940e-14, -0.104516093650e-16,
                               -0.198892668780e-19, -0.163226974860e-22 ] },
               { open_range: 0.0..1.0/0,
                      range: 0.0..1372.0,
                          c: [ -0.176004136860e-01,  0.389212049750e-01,  0.185587700320e-04,
                               -0.994575928740e-07,  0.318409457190e-09, -0.560728448890e-12,
                                0.560750590590e-15, -0.320207200030e-18,  0.971511471520e-22,
                               -0.121047212750e-25 ],
                          a: [  0.118597600000e+00, -0.118343200000e-03,  0.126968600000e+03 ] } ],

      'N' => [ { open_range: -1.0/0..0.0,
                      range: -270.0..0.0,
                          c: [  0.000000000000e+00,  0.261591059620e-01,  0.109574842280e-04,
                               -0.938411115540e-07, -0.464120397590e-10, -0.263033577160e-11,
                               -0.226534380030e-13, -0.760893007910e-16, -0.934196678350e-19 ] },
               { open_range: 0.0..1.0/0,
                      range: 0.0..1300.0,
                          c: [  0.000000000000e+00,  0.259293946010e-01,  0.157101418800e-04,
                                0.438256272370e-07, -0.252611697940e-09,  0.643118193390e-12,
                               -0.100634715190e-14,  0.997453389920e-18, -0.608632456070e-21,
                                0.208492293390e-24, -0.306821961510e-28 ] } ],

      'R' => [ { open_range: -1.0/0..1064.18,
                      range: -50.0..1064.18,
                          c: [  0.000000000000e+00,  0.528961729765e-02,  0.139166589782e-04,
                               -0.238855693017e-07,  0.356916001063e-10, -0.462347666298e-13,
                                0.500777441034e-16, -0.373105886191e-19,  0.157716482367e-22,
                               -0.281038625251e-26 ] },
               { open_range: 1064.18..1664.50,
                      range: 1064.18..1664.50,
                          c: [  0.295157925316e+01, -0.252061251332e-02,  0.159564501865e-04,
                               -0.764085947576e-08,  0.205305291024e-11, -0.293359668173e-15 ] },
               { open_range: 1664.50..1.0/0,
                      range: 1664.50..1768.10,
                          c: [  0.152232118209e+03, -0.268819888545e+00,  0.171280280471e-03,
                               -0.345895706453e-07, -0.934633971046e-14 ] } ],

      'S' => [ { open_range: -1.0/0..1064.18,
                      range: -50.0..1064.18,
                          c: [  0.000000000000e+00,  0.540313308631e-02,  0.125934289740e-04,
                               -0.232477968689e-07,  0.322028823036e-10, -0.331465196389e-13,
                                0.255744251786e-16, -0.125068871393e-19,  0.271443176145e-23 ] },
               { open_range: 1064.18..1664.50,
                      range: 1064.18..1664.50,
                          c: [  0.132900444085e+01,  0.334509311344e-02,  0.654805192818e-05,
                               -0.164856259209e-08,  0.129989605174e-13 ] },
               { open_range: 1664.50..1.0/0,
                      range: 1664.50..1768.10,
                          c: [  0.146628232636e+03, -0.258430516752e+00,  0.163693574641e-03,
                               -0.330439046987e-07, -0.943223690612e-14 ] } ],

      'T' => [ { open_range: -1.0/0..0.0,
                      range: -270.0..0.0,
                          c: [  0.000000000000e+00, 0.387481063640e-01, 0.441944343470e-04,
                                0.118443231050e-06, 0.200329735540e-07, 0.901380195590e-09,
                                0.226511565930e-10, 0.360711542050e-12, 0.384939398830e-14,
                                0.282135219250e-16, 0.142515947790e-18, 0.487686622860e-21,
                                0.107955392700e-23, 0.139450270620e-26, 0.797951539270e-30 ] },
               { open_range: 0.0..1.0/0,
                      range: 0.0..400.0,
                          c: [  0.000000000000e+00, 0.387481063640e-01, 0.332922278800e-04,
                                0.206182434040e-06, -0.218822568460e-08, 0.109968809280e-10,
                               -0.308157587720e-13, 0.454791352900e-16, -0.275129016730e-19 ] } ]
    }

  #
  # INVERSE FUNCTION COEFFICIENTS
  #
  T90_EQUATIONS  = 
    { 
      'B' => [ { open_range: -1.0/0..2.431,
                      range: 0.290..2.431,
                          d: [  9.8423321e+01,  6.9971500e+02, -8.4765304e+02,  
                                1.0052644e+03, -8.3345952e+02,  4.5508542e+02,  
                               -1.5523037e+02,  2.9886750e+01, -2.4742860e+00 ] }, 
               { open_range: 2.431..1.0/0,
                      range: 2.431..13.821,
                          d: [  2.1315071e+02,  2.8510504e+02, -5.2742887e+01,
                                9.9160804e+00, -1.2965303e+00,  1.1195870e-01,
                               -6.0625199e-03,  1.8661696e-04, -2.4878585e-06 ] } ],
      'E' => [ { open_range: -1.0/0..0.000,
                      range: -8.825..0.000,
                          d: [  0.0000000e+00,  1.6977288e+01, -4.3514970e-01, 
                               -1.5859697e-01, -9.2502871e-02, -2.6084314e-02, 
                               -4.1360199e-03, -3.4034030e-04, -1.1564890e-05, 
                                0.0000000e+00 ] },
               { open_range: 0.00..1.0/0,
                      range: 0.00..76.373,
                          d: [  0.0000000e+00,  1.7057035e+01, -2.3301759e-01,
                                6.5435585e-03, -7.3562749e-05, -1.7896001e-06,
                                8.4036165e-08, -1.3735879e-09,  1.0629823e-11,
                               -3.2447087e-14 ] } ], 
      'J' => [ { open_range: -1.0/0..0.000,
                      range: -8.096..0.000,
                          d: [  0.0000000e+00,  1.9528268e+01, -1.2286185e+00,  
                               -1.0752178e+00, -5.9086933e-01, -1.7256713e-01,  
                               -2.8131513e-02, -2.3963370e-03, -8.3823321e-05 ] },
               { open_range: 0.000..42.919,
                      range: 0.000..42.919,
                          d: [  0.000000e+00, 1.978425e+01, -2.001204e-01,
                                1.036969e-02, -2.549687e-04, 3.585153e-06,
                               -5.344285e-08, 5.099890e-10 ] },
               { open_range: 42.919..1.0/0,
                      range: 42.919..69.554,
                          d: [ -3.11358187e+03,  3.00543684e+02, -9.94773230e+00,
                                1.70276630e-01, -1.43033468e-03,  4.73886084e-06 ] } ],
      'K' => [ { open_range: -1.0/0..0.000,
                      range: -5.892..0.000,
                          d: [  0.0000000e+00,  2.5173462e+01, -1.1662878e+00,  
                               -1.0833638e+00, -8.9773540e-01, -3.7342377e-01,  
                               -8.6632643e-02, -1.0450598e-02, -5.1920577e-04  ] },
               { open_range: 0.000..20.644,
                      range: 0.000..20.644,
                          d: [  0.000000e+00,  2.508355e+01,  7.860106e-02,
                               -2.503131e-01,  8.315270e-02, -1.228034e-02,
                                9.804036e-04, -4.413030e-05,  1.057734e-06,
                               -1.052755e-08 ] },
               { open_range: 20.644..1.0/0,
                      range: 20.644..54.887,
                          d: [ -1.318058e+02,  4.830222e+01, -1.646031e+00,
                                5.464731e-02, -9.650715e-04,  8.802193e-06,
                               -3.110810e-08 ] } ],
      'N' => [ { open_range: -1.0/0..0.000,
                      range: -3.991..0.000,
                          d: [  0.0000000e+00,  3.8436847e+01,  1.1010485e+00,  
                                5.2229312e+00,  7.2060525e+00,  5.8488586e+00,  
                                2.7754916e+00,  7.7075166e-01,  1.1582665e-01,  
                                7.3138868e-03 ] }, 
               { open_range: 0.000..20.613,
                      range: 0.000..20.613,
                          d: [  0.00000e+00,  3.86896e+01, -1.08267e+00,
                                4.70205e-02, -2.12169e-06, -1.17272e-04,
                                5.39280e-06, -7.98156e-08 ] },
               { open_range: 20.613..1.0/0,
                      range: 20.613..47.513,
                          d: [  1.972485e+01,  3.300943e+01, -3.915159e-01,
                                9.855391e-03, -1.274371e-04,  7.767022e-07 ] } ],
      'R' => [ { open_range: -1.0/0..1.923,
                      range: -0.227..1.923,
                          d: [  0.0000000E+00,  1.8891380E+02, -9.3835290E+01,   
                                1.3068619E+02, -2.2703580E+02,  3.5145659E+02,   
                               -3.8953900E+02,  2.8239471E+02, -1.2607281E+02,   
                                3.1353611E+01, -3.3187769E+00 ] },
               { open_range: 1.923..13.228,
                      range: 1.923..13.228,
                          d: [  1.334584505E+01,  1.472644573E+02, -1.844024844E+01,
                                4.031129726E+00, -6.249428360E-01,  6.468412046E-02,
                               -4.458750426E-03,  1.994710149E-04, -5.313401790E-06,
                                6.481976217E-08 ] },
               { open_range: 11.361..19.739,
                      range: 11.361..19.739,
                          d: [ -8.199599416E+01,  1.553962042E+02, -8.342197663E+00,
                                4.279433549E-01, -1.191577910E-02,  1.492290091E-04 ] },
               { open_range: 19.739..1.0/0,
                      range: 19.739..21.103,
                          d: [  3.406177836E+04, -7.023729171E+03,  5.582903813E+02,
                               -1.952394635E+01,  2.560740231E-01 ] } ],
      'S' => [ { open_range: -1.0/0..1.874,
                      range: -0.236..1.874,
                          d: [  0.00000000E+00,  1.84949460E+02, -8.00504062E+01, 
                                1.02237430E+02, -1.52248592E+02,  1.88821343E+02, 
                               -1.59085941E+02,  8.23027880E+01, -2.34181944E+01, 
                                2.79786260E+00 ] },
               { open_range: 1.874..11.950,
                      range: 1.874..11.950,
                          d: [  1.291507177E+01,  1.466298863E+02, -1.534713402E+01, 
                                3.145945973E+00, -4.163257839E-01,  3.187963771E-02, 
                               -1.291637500E-03,  2.183475087E-05, -1.447379511E-07, 
                                8.211272125E-09 ] },
               { open_range: 10.332..17.536,
                      range: 10.332..17.536,
                          d: [ -8.087801117E+01,  1.621573104E+02, -8.536869453E+00, 
                                4.719686976E-01, -1.441693666E-02,  2.081618890E-04 ] },
               { open_range: 17.536..1.0/0,
                      range: 17.536..18.693,
                          d: [  5.333875126E+04, -1.235892298E+04,  1.092657613E+03,
                               -4.265693686E+01,  6.247205420E-01 ] } ],
      'T' => [ { open_range: -1.0/0..0.000,
                      range: -5.603..0.000,
                          d: [  0.0000000E+00,  2.5949192E+01, -2.1316967E-01, 
                                7.9018692E-01,  4.2527777E-01,  1.3304473E-01, 
                                2.0241446E-02,  1.2668171E-03 ] },
               { open_range: 0.000..1.0/0,
                      range: 0.000..20.872,
                          d: [  0.000000E+00,  2.592800E+01, -7.602961E-01,
                                4.637791E-02, -2.165394E-03,  6.048144E-05,
                               -7.293422E-07] } ]
  }
end
