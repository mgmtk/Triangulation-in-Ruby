#!/usr/bin/env ruby

# Name:MItchell Mesecher

#Point class initializes a point object 
#with the input cooridinites of x and y
class Point
    
    #make x and y accessible
    attr_accessor :x,:y

    #initialize the object
    def initialize(x,y)
        @x, @y = x, y
    end

    #return true if point p is eqaul to self
    def ==(p)
        (@x == p.x && @y == p.y)
    end

    #1 if self is greater than p
    #0 if points are equal 
    #-1 p is greater
    def <=>(p) #1,0,-1
        a = (@x <=> p.x) 
        if(a == 0)
            a = (@y <=> p.y)
        end 
        return a
    end

end

#initialize a CWWTriple object
#rearrange point ordering if not 
#already a left hand turn
class CCWTriple
    
    #set points to class attributes
    def initialize(p1,p2,p3) 
        if(!lefthand_turn?(p1,p2,p3))
            @p1, @p2, @p3 = p1,p3,p2
        else @p1, @p2, @p3 = p1,p2,p3 end
        
    end
    attr_accessor :p1,:p2,:p3

    #return true if CCWtriple tri is equal to self
    def ==(tri) 
        a = [@p1,@p2,@p3].permutation.select{|a,b,c| (a == tri.p1 && b == tri.p2 && c == tri.p3)}
        a.any? #check if array has any items
    end
             
end

#create Triangle alias
Triangle = CCWTriple


class PointSet
    
    attr_accessor :points

    #initialize points array
    def initialize(points)
        #set as new array as default
        if(points.size == 0)
            @points = Array.new
        end
        @points = points
    end

    #return size if points
    def size()
        @points.size
    end

    #add new point if not already included in array
    def add(p) 
        if(!@points.include?(p))
            @points << p
        end
    end
    
    # return true of point object is included in array
    def include?(p)
        @points.include?(p)
    end

    #return all triangle objects that exist in the set 
    def all_triples()
        return [] if(@points.size < 3) #check for more than 2 items
        x = Array.new
        @points.combination(3).each {|a,b,c| x << CCWTriple.new(a,b,c)} #combine all points to Triangle objects
        return x
    end

    #returns true if the triangle is a delaunay_triangle of the set
    def is_delaunay_triangle?(tri) 
        @points.each do |x|
            if(in_circle?(x, tri.p1, tri.p2, tri.p3))
                return false
            end
        end
        return true
    end
    
    #return a set of all delaunay triangles
    def delaunay_triangles() 
        #use all triples to find delaunay_triangles in the set
        all_triples.select{|x| is_delaunay_triangle?(x)}
    end

    #return a set of minimium x and y component 
    def bounds()
        a = Array.new
        minx, miny = ((2**31) - 1),((2**31) - 1)
        maxx, maxy = 0, 0
        @points.each {|x| (x.x > maxx) ?  maxx = x.x : maxx = maxx; (x.y > maxy) ? maxy = x.y : maxy = maxy}
        @points.each {|x| (x.x < minx) ?  minx = x.x : minx = minx; (x.y < miny) ? miny = x.y : miny = miny}
        a << minx << miny << (maxx - minx) << (maxy - miny) 

    end   
    
end


# Provided helper functions (DO NOT EDIT PAST THIS LINE!!!)

# Returns true iff point p is in the cicle defined by points p1, p2, and p3.
def in_circle? p, p1, p2, p3
  p1 != p && p2 != p && p3 != p &&
  det4(p1.x, p1.y, p1.x*p1.x + p1.y*p1.y, 1,
       p2.x, p2.y, p2.x*p2.x + p2.y*p2.y, 1,
       p3.x, p3.y, p3.x*p3.x + p3.y*p3.y, 1,
       p.x, p.y, p.x*p.x + p.y*p.y, 1) > 0
end

# Returns true if traveling from p1 to p2, then turning toward p3 is a left-hand
# turn; returns false if its a right-hand turn or p1, p2, and p3 are collinear.
def lefthand_turn?(p1, p2, p3)
  (p2.x-p1.x)*(p3.y-p1.y) - (p3.x-p1.x)*(p2.y-p1.y) > 0
end

# Utility function: calculate determinant of 2x2 matrix
# | a b |
# | c d |
def det2 a, b,
         c, d
  a*d - b*c
end

# Utility function: calculate determinant of 3x3 matrix
# | a b c |
# | d e f |
# | g h i |
def det3 a, b, c,
         d, e, f,
         g, h, i
  a * (det2 e, f, h, i) -
  b * (det2 d, f, g, i) +
  c * (det2 d, e, g, h)
end

# Utility function: calculate determinant of 4x4 matrix
# | a b c d |
# | e f g h |
# | i j k l |
# | m n o p |
def det4 a, b, c, d,
         e, f, g, h,
         i, j, k, l,
         m, n, o, p
  a * (det3 f, g, h, j, k, l, n, o, p) -
  b * (det3 e, g, h, i, k, l, m, o, p) +
  c * (det3 e, f, h, i, j, l, m, n, p) -
  d * (det3 e, f, g, i, j, k, m, n, o)
end

