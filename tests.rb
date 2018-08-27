
#******************TEST CASES***************************
class Points_Test <Test::Unit::TestCase 


    def test_point
        p1 = Point.new(2,3)
        p2 = Point.new(3,3)
        p3 = Point.new(3,3)
        assert_equal(false, p1==(p2))
        assert_equal(true, p2==(p3))
    end

    def test_compare
        p1 = Point.new(2,3)
        p2 = Point.new(3,3)
        p3 = Point.new(3,2)
        assert_equal(-1, p1<=>(p2))
        assert_equal(1, p2<=>(p1))
        assert_equal(1, p2<=>(p3))

        
    end

    def test_lefthand
        p1 = Point.new(4,6)
        p2 = Point.new(3,3)
        p3 = Point.new(1,2)
        tr = CCWTriple.new(p1,p2,p3)
        assert_equal(true, lefthand_turn?(tr.p1,tr.p2,tr.p3))
        
    end
    
    def test_trieq
        p1 = Point.new(4,6)
        p2 = Point.new(3,3)
        p3 = Point.new(1,2)
        p4 = Point.new(1,2)
        p5 = Point.new(3,3)
        p6 = Point.new(4,6)
        tr = CCWTriple.new(p1,p2,p3)
        tr1 = CCWTriple.new(p4,p5,p6)
        assert_equal(true, tr==(tr1))
    end

    def test_points
        p = PointSet.new([])
        p1 = Point.new(3,4)
        assert_equal(0, p.size())
        p.add(p1)
        assert_equal(1, p.size())
        p.add(p1)
        assert_equal(1, p.size())
        assert_equal(true, p.include?(p1))

    end

    def test_permutes
        p = PointSet.new([])
        p1 = Point.new(4,6)
        p2 = Point.new(7,5)
        p3 = Point.new(1,2)
        o_p = Point.new(8,9)
        p.add(p1)
        p.add(p2)
        p.add(p3)
        p.add(o_p)
        t = CCWTriple.new(p1,o_p,p3)
        assert_equal(false, p.is_delaunay_triangle?(t))
        p.all_triples().select {|x| assert_equal(true, lefthand_turn?(x.p1,x.p2,x.p3))}
        p p.delaunay_triangles
    end
    
    def test_empty
        p = PointSet.new([])
        p1 = Point.new(4,6)
        p2 = Point.new(3,3)
        p.add(p1)
        p.add(p2)
        assert_equal([], p.all_triples)
        assert_equal([],p.delaunay_triangles)
    end
    
     def test_bounds
        p = PointSet.new([])
        p1 = Point.new(4,6)
        p2 = Point.new(3,3)
        p3 = Point.new(1,2)
        p.add(p1)
        p.add(p2)
        p.add(p3)
        a = p.bounds()
        assert_equal(1, a[0])
        assert_equal(2, a[1])
        assert_equal(3, a[2])
        assert_equal(4, a[3])
     end
end


#**
