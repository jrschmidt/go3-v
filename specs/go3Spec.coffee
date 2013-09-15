describe "Test of Go3 browser side code", ->

  beforeEach ->

    @zip = new Zipper()


  describe "App Creation Test", ->

    it "should create a Zipper object", ->
      expect(@zip).toBeDefined
      expect(@zip).toEqual(jasmine.any(Zipper))

    it "should create a LegalPlayablePoints object", ->
      expect(@zip.lpp).toBeDefined
      expect(@zip.lpp).toEqual(jasmine.any(LegalPlayablePoints))


  describe "Board Test", ->
    # (We are not testing the actual Canvas rendering of the board or the
    # rendering of moves made in the game in this suite of Jasmine tests.)

    it "should create a Board object", ->
      expect(@zip.board).toBeDefined
      expect(@zip.board).toEqual(jasmine.any(Board))

