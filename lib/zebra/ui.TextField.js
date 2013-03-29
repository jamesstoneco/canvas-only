(function(pkg, Class) {

var ME = pkg.MouseEvent, KE = pkg.KeyEvent, PO = zebra.util.Position;

pkg.TextField = Class(pkg.Label, pkg.KeyListener, pkg.MouseListener, pkg.MouseMotionListener,
                      pkg.FocusListener, pkg.Cursorable, pkg.ScrollListener, pkg.CopyCutPaste, [

    function $clazz() {
        this.TextPosition = Class(PO, [
            function (render){
                  this.$super(render);
                  render.target._.add(this);
            },

            function $prototype() {
                this.textUpdated = function(src,b,off,size,startLine,lines){
                      if(b === true) this.inserted(off, size);
                      else this.removed(off, size);
                };
            },

            function destroy() { this.metrics.target._.remove(this); }
        ]);
    },

    function $prototype() {
        this.selectionColor = this.curView = this.position = null;
        this.isEditable = true;

        this.getTextRowColAt = function(render,x,y){
            var size = render.target.getLines();
            if (size === 0) return null;

            var lh = render.getLineHeight(), li = render.getLineIndent(),
                ln = (y < 0) ? 0 : ~~((y + li) / (lh + li)) + ((y + li) % (lh + li) > li ? 1 : 0) -1;

            if(ln >= size) return [size - 1, render.getLine(size - 1).length];
            else if (ln < 0) return [0,0];

            if(x < 0) return [ln, 0];

            var x1 = 0, x2 = 0, s = render.getLine(ln);
            for(var c = 0; c < s.length; c++){
                x1 = x2;
                x2 = render.font.charsWidth(s, 0, c + 1);
                if(x >= x1 && x < x2) return [ln, c];
            }
            return [ln, s.length];
        };

        this.findNextWord = function(t,line,col,d){
            if(line < 0 || line >= t.getLines()) return null;
            var ln = t.getLine(line);
            col += d;
            if(col < 0 && line > 0) return [line - 1, t.getLine(line - 1).length];
            else
                if(col > ln.length && line < t.getLines() - 1) return [line + 1, 0];

            var b = false;
            for(; col >= 0 && col < ln.length; col += d){
                if(b){
                    if(d > 0){ if(zebra.util.isLetter(ln[col])) return [line, col]; }
                    else if (!zebra.util.isLetter(ln[col])) return [line, col + 1];
                }
                else  b = d > 0 ? !zebra.util.isLetter(ln[col]) : zebra.util.isLetter(ln[col]);
            }
            return (d > 0 ? [line, ln.length ]: [line, 0]);
        };

        this.getSubString = function(r,start,end){
            var res = [], sr = start[0], er = end[0], sc = start[1], ec = end[1];
            for(var i = sr; i < er + 1; i++){
                var ln = r.getLine(i);
                if (i != sr) res.push('\n');
                else ln = ln.substring(sc);
                if(i == er) ln = ln.substring(0, ec - ((sr == er) ? sc : 0));
                res.push(ln);
            }
            return res.join('');
        };

        this.removeSelected = function(){
            if(this.hasSelection()){
                var start = Math.min(this.startOff, this.endOff);
                this.remove(start, Math.max(this.startOff, this.endOff) - start);
                this.clearSelection();
            }
        };

        this.startSelection = function(){
            if(this.startOff < 0){
                var pos = this.position;
                this.endLine = this.startLine = pos.currentLine;
                this.endCol = this.startCol = pos.currentCol;
                this.endOff = this.startOff = pos.offset;
            }
        };

        this.keyTyped = function(e){
            if (e.isControlPressed() || e.isCmdPressed() || this.isEditable === false || 
                (e.ch == '\n' && zebra.instanceOf(this.view.target, zebra.data.SingleLineTxt)))
            {
                return;
            }

            this.removeSelected();
            this.write(this.position.offset, e.ch);
        };

        this.selectAll_command = function() {
            this.select(0, this.position.metrics.getMaxOffset());
        };

        this.nextWord_command = function(b, d) {
            if (b) this.startSelection();
            var p = this.findNextWord(this.view.target, this.position.currentLine, this.position.currentCol, d);
            if(p != null) this.position.setRowCol(p[0], p[1]);
        };

        this.nextPage_command = function(b, d) { 
            if (b) this.startSelection();
            this.position.seekLineTo(d == 1 ? PO.DOWN : PO.UP, this.pageSize()); 
        };

        this.keyPressed = function(e) {
            if (this.isFiltered(e)) return;

            var position    = this.position, 
                col         = position.currentCol, 
                isShiftDown = e.isShiftPressed(),
                line        = position.currentLine, 
                foff        = 1;
            
            if (isShiftDown && e.ch == KE.CHAR_UNDEFINED) { 
                this.startSelection();
            }

            switch(e.code)
            {
                case KE.DOWN: position.seekLineTo(PO.DOWN);break;
                case KE.UP: position.seekLineTo(PO.UP);break;
                case KE.LEFT : foff = -1;
                case KE.RIGHT:
                    if (e.isControlPressed() === false && e.isCmdPressed() === false) position.seek(foff);
                    break;
                case KE.END:
                    if(e.isControlPressed()) position.seekLineTo(PO.DOWN, position.metrics.getLines() - line - 1);
                    else position.seekLineTo(PO.END);
                    break;
                case KE.HOME:
                    if(e.isControlPressed()) position.seekLineTo(PO.UP, line);
                    else position.seekLineTo(PO.BEG);
                    break;
                case KE.DELETE:
                    if (this.hasSelection() && this.isEditable) {
                        this.removeSelected();
                    }
                    else {
                        if (this.isEditable) this.remove(position.offset, 1);
                    } break;
                case KE.BSPACE:
                    if (this.isEditable) {
                        if(this.hasSelection()) this.removeSelected();
                        else {
                            if(this.isEditable && position.offset > 0){
                                position.seek(-1);
                                this.remove(position.offset, 1);
                            }
                        }
                    } break;
                default: return ;
            }
            if (isShiftDown === false && this.isEditable) this.clearSelection();
        };

        this.isFiltered = function(e){
            var code = e.code;
            return code == KE.SHIFT || code == KE.CTRL || code == KE.TAB || code == KE.ALT || (e.mask & KE.M_ALT) > 0;
        };

        this.remove = function (pos,size){
            var position = this.position;
            if (pos >= 0 && (pos + size) <= position.metrics.getMaxOffset()) {
                if (this.isEditable && size < 10000) { 
                    this.historyPos = (this.historyPos + 1) % this.history.length;
                    this.history[this.historyPos] = [-1, pos, this.getValue().substring(pos, pos+size)]; 
                    if (this.undoCounter < this.history.length) this.undoCounter++;
                }

                var pl = position.metrics.getLines(), old = position.offset;
                this.view.target.remove(pos, size);
                if (position.metrics.getLines() != pl || old == pos) this.repaint();
            }
        };

        this.write = function (pos,s){
            if (this.isEditable && s.length < 10000) { 
                this.historyPos = (this.historyPos + 1) % this.history.length;
                this.history[this.historyPos] = [1, pos, s.length];
                if (this.undoCounter < this.history.length) this.undoCounter++;
            }

            var old = this.position.offset, m = this.view.target, pl = m.getLines();
            m.write(s, pos);
            if (m.getLines() != pl || this.position.offset == old) this.repaint();
        };

        this.recalc = function() { this.validateCursorMetrics(); };

        this.validateCursorMetrics = function() {
            var r = this.view, p = this.position;
            if(p.offset >= 0){
                var cl = p.currentLine;
                this.curX = r.font.charsWidth(r.getLine(cl), 0, p.currentCol) + this.getLeft();
                this.curY = cl * (r.getLineHeight() + r.getLineIndent()) + this.getTop();
            }
            this.curH = r.getLineHeight() - 1;
        };

        this.getCursorType = function(target,x,y){ return pkg.Cursor.TEXT; };

        this.getScrollManager = function (){ return this.sman;};
        this.scrolled = function (psx,psy){ this.repaint(); };
        this.canHaveFocus = function (){ return true;};

        this.drawCursor = function (g){
            if (this.isEditable && this.hasFocus() && this.position.offset >= 0 && this.curView != null){
                this.curView.paint(g, this.curX, this.curY, this.curW, this.curH, this);
            }
        };

        this.startDragged = function (e){
            if ((e.mask & ME.LEFT_BUTTON) > 0 && this.position.metrics.getMaxOffset() > 0) { 
                this.startSelection();
            }
        };

        this.endDragged =function (e){
            if ((e.mask & ME.LEFT_BUTTON) > 0 && this.hasSelection() === false) this.clearSelection();
        };

        this.mouseDragged = function (e){
            if((e.mask & ME.LEFT_BUTTON) > 0){
                var p = this.getTextRowColAt(this.view, e.x - this.sman.getSX(), e.y - this.sman.getSY());
                if(p != null) this.position.setRowCol(p[0], p[1]);
            }
        };

        this.select = function (startOffset,endOffset){
            if (endOffset < startOffset || startOffset < 0 || endOffset > this.position.metrics.getMaxOffset()){
                throw new Error("Invalid selection offsets");
            }

            if (this.startOff != startOffset || endOffset != this.endOff){
                if(startOffset == endOffset) this.clearSelection();
                else {
                    this.startOff = startOffset;
                    var p = this.position.getPointByOffset(startOffset);
                    this.startLine = p[0];
                    this.startCol = p[1];
                    this.endOff = endOffset;
                    p = this.position.getPointByOffset(endOffset);
                    this.endLine = p[0];
                    this.endCol = p[1];
                    this.repaint();
                }
            }
        };

        this.hasSelection = function (){ return this.startOff != this.endOff; };

        this.posChanged = function (target,po,pl,pc){
            this.validateCursorMetrics();
            var position = this.position;
            if(position.offset >= 0){
                var lineHeight = this.view.getLineHeight(), top = this.getTop();
                this.sman.makeVisible(this.curX, this.curY, this.curW, lineHeight);
                if(pl >= 0){
                    if(this.startOff >= 0){
                        this.endLine = position.currentLine;
                        this.endCol = position.currentCol;
                        this.endOff = position.offset;
                    }
                    var minUpdatedLine = Math.min(pl, position.currentLine), li = this.view.getLineIndent(), 
                        bottom = this.getBottom(), left = this.getLeft(),
                        y1 = lineHeight * minUpdatedLine + minUpdatedLine * li + top + this.sman.getSY();
                    if(y1 < top) y1 = top;
                    if(y1 < this.height - bottom){
                        var h = (Math.max(pl, position.currentLine) - minUpdatedLine + 1) * (lineHeight + li);
                        if( y1 + h > this.height - bottom) h = this.height - bottom - y1;
                        this.repaint(left, y1, this.width - left - this.getRight(), h);
                    }
                }
                else this.repaint();
            }
        };

        this.paintOnTop = function(g) {
            if (this.hint && this.hasFocus() === false && this.getValue() == '') {
                this.hint.paint(g, this.getLeft(), this.height - this.getBottom() - this.hint.getLineHeight(), 
                                this.width, this.height, this);
            }
        };

        this.setHint = function(hint, font, color) {
            this.hint = hint;
            if (hint != null && zebra.instanceOf(hint, pkg.View) === false) {
                this.hint = new pkg.TextRender(hint);
                font  = font  ? font  : pkg.TextField.hintFont;
                color = color ? color : pkg.TextField.hintColor;
                this.hint.setColor(color);
                this.hint.setFont(font);
            }
            this.repaint();
            return this.hint;
        };


        this.undo_command = function() {
            if (this.undoCounter > 0) {
                var h = this.history[this.historyPos];

                this.historyPos--;
                if (h[0] == 1) this.remove(h[1], h[2]);
                else           this.write (h[1], h[2]);

                this.undoCounter -= 2;
                this.redoCounter++;

                this.historyPos--;
                if (this.historyPos < 0) this.historyPos = this.history.length - 1; 
            }
        };

        this.redo_command = function() {
            if (this.redoCounter > 0) {
                var h = this.history[(this.historyPos + 1) % this.history.length];
                if (h[0] == 1) this.remove(h[1], h[2]);
                else           this.write (h[1], h[2]);
                this.redoCounter--;
            }
        };

        this.getStartSelection = function(){
            return this.startOff != this.endOff ? ((this.startOff < this.endOff) ? [this.startLine, this.startCol]
                                                                                 : [this.endLine, this.endCol]) : null;
        };

        this.getEndSelection = function(){
            return this.startOff != this.endOff ? ((this.startOff < this.endOff) ? [this.endLine, this.endCol]
                                                                                 : [this.startLine, this.startCol]) : null;
        };

        this.getSelectedText = function(){
            return this.startOff != this.endOff ? this.getSubString(this.view, this.getStartSelection(), this.getEndSelection())
                                                : null;
        };

        this.focusGained = function (e){
            if (this.position.offset < 0) this.position.setOffset(0);
            else {
                if (this.hint != null) this.repaint();
                else {
                    if (this.isEditable) {
                        this.repaint(this.curX + this.sman.getSX(), 
                                     this.curY + this.sman.getSY(),
                                     this.curW, this.curH);
                    }
                }
            }
        };

        this.focusLost = function(e){
            if (this.isEditable) {
                if (this.hint) this.repaint();
                else {
                    this.repaint(this.curX + this.sman.getSX(), 
                                 this.curY + this.sman.getSY(),
                                 this.curW, this.curH);
                }
            }
        };

        this.clearSelection = function (){
            if(this.startOff >= 0){
                var b = this.hasSelection();
                this.endOff = this.startOff =  -1;
                if (b) this.repaint();
            }
        };

        this.pageSize = function (){
            var height = this.height - this.getTop() - this.getBottom(),
                indent = this.view.getLineIndent(), 
                textHeight = this.view.getLineHeight();
            return (((height + indent) / (textHeight + indent) + 0.5) | 0) + 
                   (((height + indent) % (textHeight + indent) > indent) ? 1 : 0);
        };

        this.createPosition = function (r){ return new pkg.TextField.TextPosition(r); };

        this.paste = function(txt){
            if(txt != null){
                this.removeSelected();
                this.write(this.position.offset, txt);
            }
        };

        this.copy = function() {
            return this.getSelectedText();
        };

        this.cut = function() {
            var t = this.getSelectedText();
            if (this.isEditable) this.removeSelected();
            return t;
        };

        this.setPosition = function (p){
            if(this.position != p){
                if(this.position != null){
                    this.position._.remove(this);
                    if (this.position.destroy) this.position.destroy();
                }
                this.position = p;
                this.position._.add(this);
                this.invalidate();
            }
        };

        this.setCursorView = function (v){
            // !!!
            // cursor size should be set by property
            this.curW = 1;
            this.curView = pkg.$view(v);
            //this.curW = this.curView != null ? this.curView.getPreferredSize().width : 1;
            this.vrp();
        };

        this.setPSByRowsCols = function (r,c){
            var tr = this.view, w = (c > 0) ? (tr.font.stringWidth("W") * c) : this.psWidth,
                h = (r > 0) ? (r * tr.getLineHeight() + (r - 1) * tr.getLineIndent()) : this.psHeight;
            this.setPreferredSize(w, h);
        };

        this.setEditable = function (b){
            if(b != this.isEditable){
                this.isEditable = b;
                this.vrp();
            }
        };

        this.mouseClicked = function(e){
            if ((e.mask & ME.LEFT_BUTTON) > 0 && e.clicks > 1) {
                this.select(0, this.position.metrics.getMaxOffset());
            }
        };

        this.mousePressed = function (e){
            if(e.isActionMask()){
                if ((e.mask & KE.M_SHIFT) > 0) this.startSelection();
                else this.clearSelection();
                var p = this.getTextRowColAt(this.view, e.x - this.sman.getSX() - this.getLeft(),
                                                        e.y - this.sman.getSY() - this.getTop());
                if(p != null) this.position.setRowCol(p[0], p[1]);
            }
        };

        this.setSelectionColor = function (c){
            if (c != this.selectionColor){
                this.selectionColor = c;
                if (this.hasSelection()) this.repaint();
            }
        };
    },

    function () { this.$this(""); },

    function(s, maxCol){
        var b = zebra.isNumber(maxCol);
        this.$this(b ? new zebra.data.SingleLineTxt(s, maxCol) : (maxCol ? new zebra.data.Text(s) : s));
        if (b && maxCol > 0) this.setPSByRowsCols(-1, maxCol);
    },

    function (render){
        if (zebra.isString(render)) { 
            render = new pkg.TextRender(new zebra.data.SingleLineTxt(render));
        }
        else {
            if (zebra.instanceOf(render, zebra.data.TextModel)) { 
                render = new pkg.TextRender(render);
            }
        }
        this.startLine = this.startCol = this.endLine = this.endCol = this.curX = 0;
        this.startOff = this.endOff = -1;
        this.history = Array(100);
        this.historyPos = -1;
        this.redoCounter = this.undoCounter = this.curY = this.curW = this.curH = 0;

        this.$super(render);
        this.sman = new pkg.ScrollManager(this);
    },

    function setView(v){
        if(v != this.view){
            this.$super(v);
            this.setPosition(this.createPosition(this.view));
        }
    },

    function setValue(s){
        var txt = this.getValue();
        if(txt != s){
            this.position.setOffset(0);
            this.sman.scrollTo(0, 0);
            this.$super(s);
        }
    },

    function paint(g){
        var sx = this.sman.getSX(), sy = this.sman.getSY();
        try{
            g.translate(sx, sy);
            this.$super(g);
            this.drawCursor(g);
        }
        catch(e) { throw e; }
        finally{ g.translate( -sx,  -sy); }
    },

    function getPreferredSize(){
        var d = this.$super();
        if (this.psWidth < 0) d.width += this.curW;
        return d;
    },

    function setEnabled(b){
        this.clearSelection();
        this.$super(b);
    }
]);

})(zebra("ui"), zebra.Class);