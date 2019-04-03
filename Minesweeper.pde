

import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
int bombNum = 0;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
 
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int rrr = 0; rrr < NUM_ROWS; rrr++)
    {
        for(int ccc = 0; ccc < NUM_COLS; ccc++)
        {
            buttons[rrr][ccc] = new MSButton(rrr,ccc);
        }
    }
    for(int sb = 0; sb < (NUM_COLS*NUM_ROWS)/40; sb++)
    {
        setBombs();
        bombNum++;
    }
}
public void setBombs()
{
    //your code
    int ranrow = (int)(Math.random()*NUM_ROWS);
    int rancol = (int)(Math.random()*NUM_COLS);
    if(!bombs.contains(buttons[ranrow][rancol]))
    {
        bombs.add(buttons[ranrow][rancol]);
    }
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    //your code here
    int countMark = 0;
    int countClick = 0;
    for(int n = 0; n < NUM_ROWS; n++)
    {
        for(int m = 0; m < NUM_COLS; m++)
        {
            if(buttons[n][m].isMarked())
            {
                countMark++;
            }
            else if(buttons[n][m].isClicked())
            {
                countClick++;
            }
        }
    }
    if(bombNum == bombs.size() && countClick + countMark == NUM_COLS*NUM_ROWS && bombNum == countMark && bombs.size() == (NUM_ROWS*NUM_COLS)-countClick)
    {
        return true;
    }
    return false;
}
public void displayLosingMessage()
{
    //your code here
    buttons[0][0].setLabel("L");
    buttons[0][1].setLabel("O");
    buttons[0][2].setLabel("S");
    buttons[0][3].setLabel("E");
}
public void displayWinningMessage()
{
    buttons[0][0].setLabel("W");
    buttons[0][1].setLabel("I");
    buttons[0][2].setLabel("N");
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT)
        {
            if(marked==true)
            {
                marked = false;
                clicked = false;
            }
            else if(marked==false)
            {
                marked = true;
                clicked = false;
            }
        }
        if(mouseButton == LEFT)
        {
            if(bombs.contains(this))
            {
                displayLosingMessage();
            }
            else if(countBombs(r,c) > 0)
            {
                setLabel("" + countBombs(r,c));
            }
            //your code here
            else
            {
                for(int rrc = r-1; rrc <= r+1; rrc++)
                {
                    for(int ccr = c-1; ccr <= c+1; ccr++)
                    {
                        if(isValid(rrc,ccr) && buttons[rrc][ccr].isClicked() == false)
                        {
                            buttons[rrc][ccr].mousePressed();
                        }
                    }
                }
            }
        }
    }
    public void draw () 
    {    
        if (marked)
            fill(0, 51, 153);
        else if( clicked && bombs.contains(this) ) 
            fill(255, 102, 255);
        else if(clicked)
            fill(255, 204, 255);
        else 
            fill(0, 170, 255);

        rect(x, y, width, height,20);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        //your code here
        if(r >= 0 && r < NUM_ROWS)
        {
            if(c >= 0 && c < NUM_COLS)
            {
                return true;
            }
        }
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        //your code here
        for(int rrrrr = row-1; rrrrr <= row+1; rrrrr++)
        {
            for(int ccccc = col-1; ccccc <= col+1; ccccc++)
            {
                if(isValid(rrrrr,ccccc) && bombs.contains(buttons[rrrrr][ccccc]))
                {
                    numBombs++;
                }
            }
        }
        return numBombs;
    }
}



