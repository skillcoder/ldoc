FROM akorn/luarocks:luajit2.1-alpine as builder
RUN apk add --no-cache unzip gcc libc-dev && \
	luarocks install ldoc 1.4.6-2


FROM alpine:3.14.2 as application
COPY --from=builder /usr/local/bin/ldoc /usr/local/bin/
COPY --from=builder /usr/local/etc/luarocks /usr/local/etc/luarocks
COPY --from=builder /usr/local/bin/lua /usr/local/bin/lua
COPY --from=builder /usr/local/share/lua/5.1/ /usr/local/share/lua/5.1/
COPY --from=builder /usr/local/lib/lua/5.1/ /usr/local/lib/lua/5.1/
COPY --from=builder /usr/local/lib/luarocks/ /usr/local/lib/luarocks/
COPY --from=builder /usr/lib/libgcc_s.so.1 /usr/lib/
