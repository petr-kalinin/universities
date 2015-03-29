describe "University", ->
    it "should be created with name", ->
        spyOn Universities.collection, "insert"
            .and.returnValue true

        Universities.create "University 1"
 
        expect(Universities.collection.insert).toHaveBeenCalledWith
            name: "University 1"
                
    it "should be able to remove a university without comments", ->
        spyOn Universities.collection, "remove" 
            .and.returnValue true
        spyOn Comments, "findOneByUniversity"
            .and.returnValue null
        
        univ = Universities.collection._transform name: "Test", _id: "000"
        expect(univ).toBeDefined()
        expect(univ.canRemove()).toBe(true)
        univ.remove() 
        expect(Comments.findOneByUniversity).toHaveBeenCalledWith univ
        expect(Universities.collection.remove).toHaveBeenCalledWith "000"
        
    it "should not be able to remove a university with comments", ->
        spyOn Universities.collection, "remove" 
            .and.returnValue true
        spyOn Comments, "findOneByUniversity"
            .and.returnValue "foo"
        
        univ = Universities.collection._transform name: "Test", _id: "000"
        expect(univ).toBeDefined()
        expect(univ.canRemove()).toBe(false)
        try
            univ.remove()
        catch error
            expect(error.error).toBe("cant-remove")
        expect(Comments.findOneByUniversity).toHaveBeenCalledWith univ
        expect(Universities.collection.remove).not.toHaveBeenCalled

    it "should be able to find all universities", ->
        spyOn Universities.collection, "find"
            .and.returnValue "foo"
        
        result = Universities.findAll()
        
        expect(result).toBe("foo")
        expect(Universities.collection.find).toHaveBeenCalledWith {}, {}

    it "should be able to find all sorted universities", ->
        spyOn Universities.collection, "find"
            .and.returnValue "foo"
        
        result = Universities.findAll(true)
        
        expect(result).toBe("foo")
        expect(Universities.collection.find).toHaveBeenCalledWith {}, sort: {name: 1}

    it "should be able to find universities by its id", ->
        spyOn Universities.collection, "findOne"
            .and.returnValue "foo"
        
        result = Universities.findById("bar")
        
        expect(result).toBe("foo")
        expect(Universities.collection.findOne).toHaveBeenCalledWith _id: "bar"
