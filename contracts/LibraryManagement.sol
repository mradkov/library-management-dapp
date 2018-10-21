pragma solidity ^0.4.18;

import './common/Ownable.sol';
import './common/Destructible.sol';
import './libs/SafeMath.sol';

contract LibraryManagament is Destructible {
    /** USINGS */
    using SafeMath for uint256;

    /** STRUCTS */
    struct Book {
        uint isbn;
        bytes title;
        bytes author;
        uint256 year;
        uint rentalPricePerDay;
        uint expires;
        address rentedBy;
        bool active;
    }

    struct User {
        bool registered;
        uint booksCurrentlyRented;
        uint balance;
    }
    
    /** CONSTANTS */
    uint constant public PAYMENT_TYPE_TOPUP = 1;
    uint constant public DEFAULT_EMPTY_ISBN = 0;

    /** STATE VARIABLES */
    mapping (uint => Book) public bookDetails;
    mapping(address => User) public usersList;

    /** MODIFIERS */
    modifier isBookActive(uint isbn) {
        require(bookDetails[isbn].active == true);
        _;
    }

    modifier isBookAvailable(uint isbn) {
        require(bookDetails[isbn].rentedBy == 0x0);
        _;
    }

    modifier collectBookPayment(uint isbn) {
        require(msg.value >= bookDetails[isbn].price);
        _;
    }

    modifier isUserRegistered() {
        require(usersList[msg.sender].registered == false);
        _;
    }

    modifier collectPayment(uint paymentType, uint isbn) {
        if (paymentType == PAYMENT_TYPE_TOPUP) {
            require(msg.value >= 0);
            usersList[msg.sender].balance.add(msg.value);
        } else {
            require(msg.value >= booksDetails[isbn].rentalPricePerDay);
        }

        _;
    }

    /**
     *  EVENTS
     */
    event LogNewBookAdded(uint indexed timestamp, uint isbn, bytes32 title);
    event LogBookEdited(uint indexed timestamp, uint isbn, address manager);
    event LogNewUserRegistered(uint indexed timestamp, address user);
    event LogUserAccountToppedUp(uint indexed timestamp, address user, uint amount);

    /**
     * @dev - Constructor of the contract
     */
    function LibraryManagement() public {
        
    }
    
    /*
     * @dev - function to add new book to the library
     * @param isbn - new book's isbn
     * @param title - new book's title
     * @param author - new book's author
     * @param year - new book's year
     * @param price - new book's price
     */
    function addBook(uint isbn, bytes32 title, bytes32 author, uint256 year, uint price) public onlyOwner {
        Book memory newBook = Book({isbn: isbn, title: title, author: author, year: year, rented: 0});
        bookDetails[isbn] = newBook;
        LogNewBookAdded(block.timestamp, isbn, title);
    }

    /*
     * @dev - function to edit book details
     * @param isbn - the edited book's isbn
     * @param title - the edited book's title
     * @param author - the edited book's author
     * @param year - the edited book's year
     * @param price - the edited book's price
     */
    function editBook(uint isbn, bytes32 title, bytes32 author, uint256 year, uint price, uint rented, uint active) public onlyOwner {
        bookDetails[isbn].title = title;
        bookDetails[isbn].author = author;
        bookDetails[isbn].year = year;
        bookDetails[isbn].price = price;
        bookDetails[isbn].rented = rented;
        bookDetails[isbn].active = active;
        LogBookEdited(block.timestamp, isbn, msg.sender);
    }

    /*
     * @dev - function to remove a book
     * @param isbn - the book's isbn
     */
    function removeBook(uint isbn) public onlyOwner isBookActive(isbn) {
        bookDetails[isbn].active = false;
    }
    
    /*
     * @dev - function to register a user
     */
    function userRegister() public isUserRegistered {
        User memory newUser = User({registered: false, booksCurrentlyRented: 0, balance: 0});
        usersList[msg.sender] = newUser;
        LogNewUserRegistered(block.timestamp, msg.sender);
    }

    function userTopUp() public payable collectPayment(PAYMENT_TYPE_TOPUP, DEFAULT_EMPTY_ISBN) {
        LogUserAccountToppedUp(block.timestamp, msg.sender, msg.value);
    }

    /*
     * @dev - Get price of a book
     * @param isbn
     */
    function getBookPrice(uint isbn) public pure returns (uint) {
        return bookDetails[isbn].price;
    }
    
    /**
     * @dev - Withdraw function 
     */
    function withdraw() public onlyOwner {
        owner.transfer(address(this).balance);
    }
}