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


  describe "Click Handling Test", ->

    beforeEach ->
      @clickster = @zip.clickster

    it "should create a ClickHandler object", ->
      expect(@clickster).toBeDefined
      expect(@clickster).toEqual(jasmine.any(ClickHandler))

    describe "Message Builder Test", ->

      it "should encode a gameboard point as a two character hexadecimal string", ->
        expect(@clickster.hex_string([1,1])).toEqual("11")
        expect(@clickster.hex_string([4,3])).toEqual("43")
        expect(@clickster.hex_string([6,2])).toEqual("62")
        expect(@clickster.hex_string([6,10])).toEqual("6a")
        expect(@clickster.hex_string([6,11])).toEqual("6b")
        expect(@clickster.hex_string([10,4])).toEqual("a4")
        expect(@clickster.hex_string([11,10])).toEqual("ba")
        expect(@clickster.hex_string([11,11])).toEqual("bb")





