class ThecavePlaylist < ActiveRecord::Migration
  def self.up
    pl = Playlist.new do |p|
      p.user = User.find_by_name("deepbondi")
      p.name = "thecave"
      p.jukebox_source = true
      
      p.save
    end
    
    self.data.each do |id|
      pl.songs << Song.find(id)
    end
  end

  def self.down
  end
  
  def self.data
    [
      161774,
      161781,
      161782,
      161821,
      161822,
      161829,
      161831,
      161834,
      161843,
      161855,
      161879,
      161881,
      161891,
      161894,
      161897,
      161899,
      161906,
      161908,
      161909,
      161910,
      161973,
      161985,
      162046,
      162115,
      162121,
      162244,
      162254,
      162264,
      162268,
      162345,
      162426,
      162429,
      162434,
      162627,
      162651,
      162658,
      162876,
      163068,
      163069,
      163070,
      163078,
      163096,
      163123,
      163148,
      163149,
      163150,
      163169,
      163203,
      163206,
      163388,
      163395,
      163408,
      163410,
      163412,
      163413,
      163414,
      163419,
      163595,
      163596,
      163599,
      163604,
      163605,
      164331,
      164830,
      164831,
      164833,
      164842,
      164849,
      164850,
      164851,
      164852,
      164853,
      164855,
      164856,
      164857,
      165153,
      165156,
      165158,
      165196,
      165209,
      165348,
      165368,
      165390,
      165391,
      165471,
      165538,
      165545,
      165547,
      166063,
      166262,
      166268,
      166272,
      166417,
      166418,
      166419,
      166427,
      166429,
      166446,
      166467,
      166472,
      167804,
      169267,
      169629,
      169635,
      169638,
      169641,
      169816,
      169820,
      169824,
      169826,
      169831,
      169837,
      169840,
      169935,
      169993,
      170002,
      170008,
      170043,
      170045,
      170092,
      170185,
      170197,
      170204,
      170205,
      170206,
      170209,
      170210,
      170211,
      170212,
      170213,
      170215,
      170218,
      170219,
      170220,
      170222,
      170224,
      170225,
      170230,
      170360,
      170361,
      170362,
      170363,
      170366,
      170480,
      170497,
      170516,
      170519,
      170522,
      170523,
      170524,
      170529,
      170535,
      170537,
      170837,
      171081,
      171177,
      171179,
      171197,
      171198,
      171207,
      171209,
      171234,
      171284,
      171309,
      171313,
      171315,
      171318,
      171335,
      171342,
      171527,
      171531,
      171544,
      171548,
      171552,
      171562,
      171567,
      171588,
      171612,
      171622,
      171625,
      171627,
      171628,
      171629,
      171635,
      171636,
      171641,
      171696,
      171700,
      171703,
      171866,
      171911,
      171912,
      172019,
      172021,
      172024,
      172025,
      172028,
      172029,
      172087,
      172167,
      172169,
      172170,
      172601,
      172605,
      172606,
      172609,
      172610,
      172611,
      172616,
      172617,
      172861,
      172929,
      172937,
      172940,
      172951,
      172953,
      172955,
      172975,
      172977,
      172982,
      172988,
      172996,
      173003,
      173012,
      173013,
      173014,
      173016,
      173020,
      173246,
      173248,
      173251,
      173781,
      173786,
      173811,
      173813,
      173815,
      173819,
      173824,
      173826,
      173836,
      173855,
      173858,
      173863,
      173864,
      173865,
      173871,
      173873,
      173874,
      173876,
      173878,
      173879,
      173886,
      173887,
      173888,
      173898,
      174079,
      174091,
      174109,
      174122,
      174145,
      174150,
      174152,
      174153,
      174203,
      174660,
      174779,
      174781,
      174810,
      175036,
      177236,
      177310,
      177521,
      177524,
      179584,
      179586,
      179592,
      179593,
      179594,
      179596,
      185762,
      185763,
      185764,
      185765,
      185766,
      185772,
      185775,
      185776,
      185778,
      185779,
      185781,
      185782,
      186391,
      186396,
      186547,
      186548,
      186550,
      186551,
      186553,
      186554,
      186555,
      186556,
      186557,
      186560,
      186563,
      186567,
      186570,
      186574,
      186578,
      186579,
      186580,
      186581,
      186582,
      186583,
      186584,
      186585,
      186586,
      186587,
      186588,
      186589,
      186590,
      188171,
      188173,
      188176,
      188178,
      188260,
      188270,
      188426,
      188427,
      188428,
      188432,
      188433,
      188434,
      188435,
      188437,
      188442,
      188443,
      188448,
      188488,
      188489,
      188490,
      188492,
      188494,
      188496,
      188500,
      189262,
      189265,
      189267,
      189314,
      189317,
      189318,
      189321,
      189324,
      189329,
      189583,
      189654,
      189836,
      189844,
      189799,
      189802,
      189804,
      192256,
      192259,
      192262,
      192267,
      192258,
      192273,
      192268,
      192283,
      192269,
      192285,
      192287,
      192290,
      192337,
      192343,
      192339,
      192345,
      192368,
      192371,
      192372,
      192365,
      192357,
      192350,
      165343,
      165341,
      192752,
      192753,
      192759,
      192760,
      192758,
      192761,
      192757,
      192755,
      192754,
      192742,
      174297,
      174303,
      174295,
      180812,
      180799,
      180802,
      192432,
      180789,
      180790,
      180794
    ]
  end
end
