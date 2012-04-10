function error = calerror(objectionlocation, goundtrouth, color)
global parameter;
e = 1;
error = zeros(size(objectionlocation, 1), 1);
for imgno = 1:size(objectionlocation,1)
    if mod(e, 5) == 1
        error(e) = sqrt(  ...
            (objectionlocation(e, 1) - goundtrouth(e,1))^2 + ...
            (objectionlocation(e, 2) - goundtrouth(e,2))^2 );
    end
    e = e + 1;
end
x = 1:5:size(objectionlocation,1);
plot(x, error(x), color);
end
%{
figure
obj = zeros(size(objectionlocation, 1) - 1, 2);
obj = objectionlocation(1:size(objectionlocation, 1) - 1 , 1:2);
objn = zeros(size(objectionlocation, 1) - 1, 2);
objn = objectionlocation(2:size(objectionlocation, 1),1:2);
dist = zeros(size(objectionlocation, 1) - 1, 1);
dist = sqrt((objn(:,1) - obj(:,1)).^2 + (objn(:,2) - obj(:,2)).^2);
plot(2:size(objectionlocation, 1), dist);
%}
